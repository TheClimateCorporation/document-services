# Sojourner

Do you need to generate documents from some form of `data + template = document` ?
Do you need to manage template versions?
Do you need to be able to mark templates "ready" and "not ready" for use in a production environment?
Do you need to keep track of who did what?

Sojourner is a rails application for doing these things.

###Requirements

* An application controller method for determining `current_user_id`
* A templating engine
  * This example uses Windward Reports, which is a Java Libary.
  * You can use whatever you like by swapping out the template version's `#render` method.
* A storage election for your template files and sample documents
  * This example uses local disk storage in the development environment
  * This example uses S3 storage in the production environment.
  * You can use whatever you like by setting `StorageLocation::DEFAULT_TYPE` for your environments.
* A storage election for your generated documents
  * This example sends the documents to its sister service, [Simone](https://github.com/TheClimateCorporation/document-services/tree/master/simone). Documents are retrieved from the Simone doc store by `document_id`.
  * You can send the documents elsewhere or elect to store them within Sojourner by altering the `DocstoreConnector`.


## Getting started

To get started most quickly, use Sojourner and Simone (both applications in this repo) together. Setup instructions will assume you are doing this.

Clone the repo. In the root directory of the repo, add a `doc-services.properties` text file. This is from where you will fetch anything you don't want to commit to the repo.

If you are using only Sojourner and wish to place your propeties file somewhere else, change the `DOT_PROPERTIES_PATH` in application.rb.

Both applications require access to a SQL database; they come configured for mysql. The properties you will need to add to `doc-services.properties` are:

  * sojourner.mysql_username
  * sojourner.mysql_password
  * sojourner.document_storage.url [ http://localhost:3000 to use [Simone](https://github.com/TheClimateCorporation/document-services/tree/master/simone) by default]
  * sojourner.secret_key_base [generate with `rake secret`]
  * sojourner.default_s3_bucket_name [if using S3]
  * message_bus.stub_publishing = true [ At The Climate Corporation, we have a SOA. We notify other services when a document is ready via the message bus. Remove or alter at your leisure.]
  * windward.developer.license [if you have chosen to use the Windward engine. You can request a trial license [here](http://go.windward.net/download.html).]

Go finish setting up [Simone](https://github.com/TheClimateCorporation/document-services/tree/master/simone).

For the fastest demo of the application, skip the next paragraph and proceed. There is a dummy `current_user_id` method which will mark the user as 'DEMO + timestamp'.

For the most functional usage of the application, drop your favorite authentication solution into the application and make sure `ApplicationController#current_user_id` does something useful.

Once running `rspec` for either app does not cause any unhappy red text, start the servers by running `rails s` from each of the sojourner and simone directories. Sojourner is set up to start the server on port 3001 by default, so that it does not conflict with Simone on the default port 3000.

Go time!

## Using the application

#### Creating a template

_NB: A `Template` is the object which all of the versions of the template will `belong_to`, and the object whose ID clients will use to call for a document to be made. A `Template` object does not itself have files. The template files reside with each version of the template (`TemplateSingleVersion` objects.)_


Navigate to http://localhost:3001. (If necessary, sign in.) Click the "Create a template" button and add a name for a new template. This creates the object to group the versions under.

Next, navigate to the JSON Schemas index using the link at top of the page. Click "Create a Template schema".

A `TemplateSchema` is the declaration of what information is required to correctly fill out a document template. It contains both a [JSON-Schema](http://json-schema.org/) and a JSON stub of example data. You must have a schema to upload a template file to generate documents.

Fill out the new schema form using `sojourner/spec/fixtures/test_json_schema.json` for the 'Json schema properties' field and `sojourner/spec/fixtures/test_json_stub.json` for the 'Json stub' field.

Navigate back to the Templates index. You should see the `Template` you named earlier. Click 'show' to go to the page for that template. Your template does not have any versions yet! Click "Create a version".

To create a `TemplateSingleVersion`, you must specify a schema and a template file. You should see the schema you just made in the schema dropdown. For the file, use `sojourner/spec/fixtures/test_template.docx`. Create! You should be redirected back to the template's page and you should see your new version listed.

#### Generating a document

Now that you have a template, you are ready to generate a document! The fastest way to see a generated document is to navigate to your new template version at /templates/1/v/1 and hit "Generate Sample". This will use the stub included with the declared `TemplateSchema` to populate your template. NEAT.

To generate a document that will get sent on to Simone/your choice of doc store, I reccomend the Postman chrome app. At any rate, you will want to POST a request to `http://localhost:3001/generate` with the Content-Type header set to 'application/json', and the body like so:

```
{
	"document_name": "having_so_much_fun_testing_document_generation_with_sojourner!",
  "template_id": "1",
  "schema_id": "1",
  "document_owner_type": "anyone",
	"input_data": "{\"quote\":{\"quote-type\":\"MP\",\"quote-date\":\"today\",\"customers\":[{\"first-name\":\"Bob\",\"last-name\":\"Barker\",\"phone\":\"555-123-5432\",\"email\":\"whatdidiwinbob@jeapordy.com\"}]}}"
}
```

* the owner type of 'anyone' is to retrieve the link with minimal fuss. setting owner type of 'user' (or leaving it blank will default to user) will trigger authorization checking based on current_user_id, which is stubbed as a timestamp, so good luck with that.
* There is no version number. This is on purpose. Sojourner will use the highest version of the template that corresponds to the schema you specify.

In return, you will get a `document_id`! Sample response body:

`{"document_id":"488b46e6-e620-4402-9cd5-ee586a5c93ba"}`


This is not yet a document! Unless you've turned off queueing, return to your command line. Run `rake jobs:workoff`. _Now_ you have a document. :)


### Getting your document once it's generated

Simone says... come get your document!

See "[Retrieving an expiring read_link to a Document](https://github.com/TheClimateCorporation/document-services/tree/master/simone#retrieving-an-expiring-read_link-to-a-document)".



## More about the data models

### Template

A `Template` is the object which all of the versions of the template will `belong_to`, and the object whose ID clients will use to call for a document to be made.

By design, `Template` can either be a `TemplateSingle`, for which each version will have its own template file, or a `TemplateBundle`, which is an ordered set of `TemplateSingleVersion`s.

Right now only `TemplateSingle`s are supported, but the Windward library supports both. A bundle, for example, might be used for attaching a standardized cover page or legal disclaimer to each of several other templates.

`Template` is structured to support both types so that clients do not need to know what 'kind' of template they are asking for, and users who wish to make a simple single template do not need to assemble a single-item 'bundle' to do so.

##### TemplateSingle

This kind of template `has_many` `TemplateSingleVersion` objects, each of which has its own template file.

##### TemplateBundle

_Not yet implemented_ This kind of template will have versions which are ordered sets of TemplateSingleVersions.

### TemplateSchema

The `TemplateSchema` is the answer to the question "What information is required to fill out this template?" (json_schema_properties) and also "What would valid input_data for a generation request look like?" (json_stub)

It allow the return of informative errors for generation requests containing insufficient or malformed input_data, and it also allows the population of a `sample_document` for each `TemplateSingleVersion`

### TemplateSingleVersion
 * storable (template file)

 Note about "Enabled in Production": You will notice that it says 'false' under "Enabled in Production" for your new template version. It will still work in the development and test evironments. If you'd like to enable it, do so! You can see the history of permission changes on a template version by clicking through to its own #show page.

 Note about future templates: You can use the same `TemplateSchema` for multiple template versions, if you need exactly the same information. But you cannot edit a schema once it is attached to any template. If you'd like to build off of the schema(s) you already made, hit `clone` on the schema of your desiring.

### TemplatePermissionChange

  `TemplatePermissionChange`s are the record of when a template was or was not authorized to be used to generate documents in the production environment.

  This allows the use and verification of templates in the development and test environments before approving them for use in the production environment.

  It also allows the revokation of authorization for template versions which you no longer wish to be used.

  `TemplatePermissionChange` also tracks *who* changed the template permissions.

### SampleDocument
  * storable (pdf)

  A `SampleDocument` is an example of what a document generated with a given template would look like. It is generated with the `json_stub` of the `TemplateSchema` that the `TemplateSingleVersion` belongs to.

### StorageLocation

  A `StorageLocation` is the object responsible for storing something that belongs to another object. The StorageLocation is in charge of knowing how to save and retrieve the storable from wherever it is stored.

##### LocalStorageLocation

  Uses local disk storage. Default for the development environment.

##### S3Location

  Uses Amazon S3 storage. Default for the production environment.

##### NullLocation

  Doesn't actually store anything, but returns valid responses for the storage and retrieval messages. Default for the test environment.


### GenerationMetadata
 * storable (input_data)

  `GenerationMetadata` persists all of the information on a document generation request that would be neccesary to recreate the document.













