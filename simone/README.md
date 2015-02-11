## simone

Simone is a lightweight Rails 4 application for centralized storage of document records in a service oriented architecture. It wraps S3 to allow implementation of your own authorization rules for document retrieval.

Simone is designed to work with an ansynchronous document generation service ([Sojourner](https://github.com/TheClimateCorporation/document-services/tree/master/sojourner)) as well as direct document uploads (_eg_ scanned documents). To this end, Simone offers the reservation of a document_id prior to posting the actual contents of the document. This enables synchronous return of a document_id to client who has requested a document be generated. *Storing a document also works without an IdReservation.*


###Requirements

* An application controller method for determining `current_user_id`

* An election for your authorization scheme.
  * In this example, documents with owner type 'anyone', it will return a read link to any requestor.
  * In this example, documents with owner type 'user', it will restrict retrieval links to the `current_user_id` that matches the document's `created_by` or `owner_id`.
  * You can use whatever you want by changing the `DocumentAuthorizor.authorized?` method.

* A storage election for your documents
  * This example uses local disk storage in the development environment. (`LocalDocument`)
  * This example uses S3 storage in the production environment. (`S3Document`)
  * You can use whatever storage you'd like by changing `Document::DEFAULT_TYPE` per environment, or by adding a new Document subtype and supplying the subclass-required methods specified in the `Document` model.


## Getting Started

Clone the repo. In the root directory of the repo, add a `doc-services.properties` text file. This is from where you will fetch anything you don't want to commit to the repo.

If you wish to place your propeties file somewhere else, change the `DOT_PROPERTIES_PATH` in application.rb.

The application requires access to a SQL database; it comes configured for mysql. The properties you will need to add to `doc-services.properties` are:

  * simone.mysql_username
  * simone.mysql_password
  * simone.secret_key_base [generate with `rake secret`]
  * simone.default_s3_bucket_name [if using S3, not needed to run locally]

Once running `rspec` from the simone directory gives you no unhappy red text, start up the server by running `rails s`.

[If you are using both Simone and [Sojourner](https://github.com/TheClimateCorporation/document-services/tree/master/sojourner), rest assured they will start by default on different ports.]



## Using the application

#### IdReservations

An `IdReservation` is the promise that a document_id has been reserved, and a way of knowing what the document_id for a document will be, before the document exists. It exists to enable synchronous return of a document_id to a client, despite asynchronous document generation. (See [Sojourner](https://github.com/TheClimateCorporation/document-services/tree/master/sojourner))

*Storing a document also works without an IdReservation.*

##### Creating an IdReservation

Make a POST request to `/id_reservations`

```
curl -X POST http://localhost:3000/id_reservations -d ''
```

In return you will see something like:

```
{"id":20,"document_id":"75f0656a-3d15-45b7-b9cb-cd4c86a06478","enabled":true,"created_at":"2015-02-10T20:00:40.839Z","updated_at":"2015-02-10T20:00:40.839Z"}
```

##### Disabling an IdReservation

Make a PUT request to `/id_reservations/:document_id`, where :document_id is the reservation you want to disable.

```
curl -X PUT  http://localhost:3000/id_reservations/75f0656a-3d15-45b7-b9cb-cd4c86a06478 -d ''
```

In return you will see something like:

```
{"id":20,"document_id":"75f0656a-3d15-45b7-b9cb-cd4c86a06478","enabled":false,"created_at":"2015-02-10T20:00:40.000Z","updated_at":"2015-02-10T20:03:53.848Z"}
```

Now it says enabled: false, and no one else can use that document_id as a reservation.


#### Storing a Document

Make a POST request to `/documents` containing `document_attributes` and `document_contents`.

Without a reservation:
```
curl --form 'document_attributes[owner_type]=anyone' --form 'document_attributes[owner_id]=anyone' --form document_content=@spec/fixtures/empty.pdf http://localhost:3000/documents
```

With a reservation:

```
curl --form 'document_attributes[owner_type]=anyone' --form 'document_attributes[owner_id]=anyone' --form 'document_attributes[document_id]=76be4ed7-e1c1-420c-aae6-fdd2632af731' --form document_content=@spec/fixtures/empty.pdf http://localhost:3000/documents
```

And in return see something like:

```
{"id":27,"document_id":"76be4ed7-e1c1-420c-aae6-fdd2632af731","created_by":"DEMO USER at 16:26:09 pm 02/10/15","owner_id":"anyone","owner_type":"anyone","size_bytes":null,"content_hash":null,"uri":"/Users/caustin/dev/open_source_projects/document-services/simone/public/documents/76be4ed7-e1c1-420c-aae6-fdd2632af731/empty.pdf.ttf","name":"empty.pdf","mime_type":"application/octet-stream","notes":null,"created_at":"2015-02-11T00:26:09.979Z","updated_at":"2015-02-11T00:26:09.979Z"}
```

#### Retrieving a read_link to a Document
**S3Document:** The read_link will expire in one hour.
**LocalDocument:** The read_link will reference a fixed location in the app's public folder, and will not expire.
____________________________________________

Document `read_link` creation is always treated as a batch, and the param name is plural.

To create links (which will by default last 1 hour) for a set of document_ids:

```
echo -e `curl -d "document_ids[]=fc13e7fb-cc39-4fe7-8d84-eecdf6c213dd" -d "document_ids[]=ca222fb2-c998-498b-b489-4be1d8efc9e8" http://localhost:3000/document_links`
```

In return you will see something like:

```
[
  {
    "document_id":"ca222fb2-c998-498b-b489-4be1d8efc9e8",
    "read_link":"documents/ca222fb2-c998-498b-b489-4be1d8efc9e8/empty.pdf.ttf",
    "status":"success"
  },
  {
    "document_id":"fc13e7fb-cc39-4fe7-8d84-eecdf6c213dd",
    "read_link":"documents/fc13e7fb-cc39-4fe7-8d84-eecdf6c213dd/empty.pdf.ttf",
    "status":"success"
  }
]
```

Other possible `status` values are `unauthorized` and `not_found`.





