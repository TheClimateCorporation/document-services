An SOA document management solution
=======

Why is this useful? / What is this for?
-----------
These two applications are for:
  * [Sojourner](https://github.com/TheClimateCorporation/document-services/tree/master/sojourner)--- managing versioned document templates and generating document files from those templates.
  * [Simone](https://github.com/TheClimateCorporation/document-services/tree/master/simone)--- managing document storage (locally or wrapped around S3), and vending read links to retrieve those documents based on developer/user-defined authorization rules.

The use case that prompted us here at The Climate Corporation to build this solution grew out of our growth as a company and our service-oriented architecture. Across the platform, we had the need to both generate and directly upload documents. And many different services needed to do one or both of those things.

[Sojourner](https://github.com/TheClimateCorporation/document-services/tree/master/sojourner) was born as a template management and PDF-generation-from-templates service. Templates are versioned, and permission for whether each version can be used to generate documents in the production environment is tracked. A record is kept of each generation request, but the the service is designed to be write-only for the generated PDFs, which are sent to the sister application, Simone. Document templates require the declaration of a schema for the information required to populate the template; this allows each template to be its own documentation for how to use it and also allows the service to reject malformed or infomplete generation requests with informative errors.

[Simone](https://github.com/TheClimateCorporation/document-services/tree/master/simone) was born as a document aggregator and gatekeeper. Services cycle in and out of life, and it should not be neccesary to know each and every service that could possibly have documents for a user in order to retrieve "all" of a user's documents. Furthermore, wrapping S3 (or whatever back end you choose) for document storage allows granular authorization rules on the level of *your* user (or role), a central references for those rules (whether that be a central authorization service or a set of rules within Simone), and centralized logging of each request for document access.


Why does *this* exist?
-----------
When it came time to decide what software to use to meet the needs of our growning insurance platform, we didn't find anything that met all of those needs. We had a couple of previous iterations of document generation services and decided to decouple document generation from document access, so we built two services. #independentlyscalable


How do I use it?
-----------
You can use one or both applications. Give the (Demo Applications) a try, clone the repo, choose your template rendering engine and your storage back end(s).


