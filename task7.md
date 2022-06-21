## Improve the response time
- Issue: Get 100 times more requests than before and clients start to complain slow response time.
- Solution:
  1. Check the codebase to make sure we do write an efficient query sentence.
     - For example, using `includes` to reduce database query time, but keep it in mind that it will also comsume the space of memory. 
     - In some cases, a `SQL` statement in rails query, would also help to speed up the query, althought it is possibly hard to read.
  2. Add index for relevant databases. In this case, shipment would have many shipment items, so it's better to set index `index_shipment_item_on_invoice_id` for table `shipment_itmes`.
  3. Provide more database servers.
     - If the issue does not get better after implementing the above solutions, maybe it's time to expand the number of the database server. We may separate databases for reading and writing.
     ```yml
     production:
       primary:
         database: my_database
         adapter: mysql2
       read_only:
         database: read_only_database
         adapter: mysql2
         replica: true
     ```
     ```ruby
     class ShipmentsRecord < ApplicationRecord
       self.abstract_class = true

       connects_to database: { writing: :primary, reading: :read_only }
     end

     class Shipment < ShipmentsRecord
       ...
     end

     class ShipmentItem < ShipmentsRecord
       ...
     end
     ```
