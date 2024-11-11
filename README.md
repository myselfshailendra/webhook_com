# Webhook Demo
Third-party API endpoints are configurable in webhook config manually:
```sh
config/initializers/webhook_config.rb
```

### Steps by step:
After pulling the repository run: 

```sh
cd webhook_com
rails db:create db:migrate
rails s
```

Now project is ready to use on the url : http://localhost:3000

### Sending Webhook:
Whenever you will create/update any product it will send a webhook with the help of background Job after a successful commit and the logs will look like below:

```sh
Started PATCH "/products/9" for ::1 at 2024-11-11 23:22:29 +0530
Processing by ProductsController#update as TURBO_STREAM
  Parameters: {"authenticity_token"=>"[FILTERED]", "product"=>{"name"=>"Product Title", "description"=>"Product Description"}, "commit"=>"Update Product", "id"=>"9"}
  Product Load (1.0ms)  SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 9], ["LIMIT", 1]]
  ↳ app/controllers/products_controller.rb:48:in `load_product'
  TRANSACTION (0.1ms)  BEGIN
  ↳ app/controllers/products_controller.rb:28:in `update'
  Product Update (0.2ms)  UPDATE "products" SET "name" = $1, "description" = $2, "updated_at" = $3 WHERE "products"."id" = $4  [["name", "Product Title"], ["description", "Product Description"], ["updated_at", "2024-11-11 17:52:29.115874"], ["id", 9]]
  ↳ app/controllers/products_controller.rb:28:in `update'
  TRANSACTION (10.6ms)  COMMIT
  ↳ app/controllers/products_controller.rb:28:in `update'
[ActiveJob] Enqueued DataChangeNotifierJob (Job ID: 6d150655-843b-4ea5-ac5c-ed01c0e96680) to Async(default) with arguments: "http://localhost:4000/products", #<GlobalID:0x000075c9c38f9668 @uri=#<URI::GID gid://webhook-com/Product/9>>, "Product is successfully updated."
[ActiveJob] Enqueued DataChangeNotifierJob (Job ID: c698acd0-0f99-48e2-885f-ffcfd438a14b) to Async(default) with arguments: "http://localhost:4000/products", #<GlobalID:0x000075c9c2b464f8 @uri=#<URI::GID gid://webhook-com/Product/9>>, "Product is successfully updated."
[ActiveJob] [DataChangeNotifierJob] [6d150655-843b-4ea5-ac5c-ed01c0e96680]   Product Load (2.1ms)  SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 9], ["LIMIT", 1]]
Redirected to http://localhost:3000/products/9
[ActiveJob] [DataChangeNotifierJob] [6d150655-843b-4ea5-ac5c-ed01c0e96680] Performing DataChangeNotifierJob (Job ID: 6d150655-843b-4ea5-ac5c-ed01c0e96680) from Async(default) enqueued at 2024-11-11T17:52:29Z with arguments: "http://localhost:4000/products", #<GlobalID:0x000075c9c2bd5658 @uri=#<URI::GID gid://webhook-com/Product/9>>, "Product is successfully updated."
Completed 302 Found in 37ms (ActiveRecord: 11.8ms | Allocations: 5068)


[ActiveJob] [DataChangeNotifierJob] [c698acd0-0f99-48e2-885f-ffcfd438a14b]   Product Load (0.1ms)  SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 9], ["LIMIT", 1]]
[ActiveJob] [DataChangeNotifierJob] [c698acd0-0f99-48e2-885f-ffcfd438a14b] Performing DataChangeNotifierJob (Job ID: c698acd0-0f99-48e2-885f-ffcfd438a14b) from Async(default) enqueued at 2024-11-11T17:52:29Z with arguments: "http://localhost:4000/products", #<GlobalID:0x000075c9c2b23598 @uri=#<URI::GID gid://webhook-com/Product/9>>, "Product is successfully updated."
Started GET "/products/9" for ::1 at 2024-11-11 23:22:29 +0530
Processing by ProductsController#show as TURBO_STREAM
  Parameters: {"id"=>"9"}
  Product Load (0.4ms)  SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 9], ["LIMIT", 1]]
  ↳ app/controllers/products_controller.rb:48:in `load_product'
  Rendering layout layouts/application.html.erb
  Rendering products/show.html.erb within layouts/application
  Rendered products/show.html.erb within layouts/application (Duration: 1.1ms | Allocations: 590)
[ActiveJob] [DataChangeNotifierJob] [6d150655-843b-4ea5-ac5c-ed01c0e96680] Performed DataChangeNotifierJob (Job ID: 6d150655-843b-4ea5-ac5c-ed01c0e96680) from Async(default) in 25.8ms
  Rendered layout layouts/application.html.erb (Duration: 4.0ms | Allocations: 2340)
Completed 200 OK in 8ms (Views: 4.5ms | ActiveRecord: 0.4ms | Allocations: 3120)


[ActiveJob] [DataChangeNotifierJob] [c698acd0-0f99-48e2-885f-ffcfd438a14b] Performed DataChangeNotifierJob (Job ID: c698acd0-0f99-48e2-885f-ffcfd438a14b) from Async(default) in 23.92ms
```

### Receiving Webhook:
On the other side on different server it will be received by this as below:

```sh
Started POST "/products" for 127.0.0.1 at 2024-11-11 23:22:29 +0530
Processing by ProductsController#create as */*
  Parameters: {"record_id"=>9, "name"=>"Product Title", "description"=>"Product Description", "notification"=>"Product is successfully updated.", "timestamp"=>1731347549, "signature"=>"34397422fd6c15b495d5137fc2f8804084777e908015d1b749f4be8bd969420f", "product"=>{"name"=>"Product Title", "description"=>"Product Description"}}
  TRANSACTION (0.1ms)  BEGIN
  ↳ app/controllers/products_controller.rb:27:in `create'
  Product Create (0.5ms)  INSERT INTO "products" ("name", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Product Title"], ["description", "Product Description"], ["created_at", "2024-11-11 17:52:29.155104"], ["updated_at", "2024-11-11 17:52:29.155104"]]
  ↳ app/controllers/products_controller.rb:27:in `create'
Started POST "/products" for 127.0.0.1 at 2024-11-11 23:22:29 +0530
  TRANSACTION (2.3ms)  COMMIT
  ↳ app/controllers/products_controller.rb:27:in `create'
Redirected to http://localhost:4000/products/32
Completed 302 Found in 10ms (ActiveRecord: 2.9ms | Allocations: 2468)


Processing by ProductsController#create as */*
  Parameters: {"record_id"=>9, "name"=>"Product Title", "description"=>"Product Description", "notification"=>"Product is successfully updated.", "timestamp"=>1731347549, "signature"=>"34397422fd6c15b495d5137fc2f8804084777e908015d1b749f4be8bd969420f", "product"=>{"name"=>"Product Title", "description"=>"Product Description"}}
  TRANSACTION (1.1ms)  BEGIN
  ↳ app/controllers/products_controller.rb:27:in `create'
  Product Create (0.8ms)  INSERT INTO "products" ("name", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Product Title"], ["description", "Product Description"], ["created_at", "2024-11-11 17:52:29.167642"], ["updated_at", "2024-11-11 17:52:29.167642"]]
  ↳ app/controllers/products_controller.rb:27:in `create'
  TRANSACTION (2.8ms)  COMMIT
  ↳ app/controllers/products_controller.rb:27:in `create'
Redirected to http://localhost:4000/products/33
Completed 302 Found in 8ms (ActiveRecord: 4.7ms | Allocations: 1977)
```

### Tips:

For receiving webhook you can:
1. Use same application copy with different db name
2. Comment webhook notifications lines from products controller
3. run that application server on port 4000 as in webhook_config I used endpoint: http://localhost:4000/products

