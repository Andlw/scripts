curl -XPOST http://127.0.0.1:9200/product_v2/product/_mapping -d '{
        "capability": {
            "properties": {
                "categoryid":{
                    "type":"integer",
                    "index":"not_analyzed",
                    "store":"yes"
                },
                "scateid":{
                    "type":"integer",
                    "index":"not_analyzed",
                    "store":"yes"
                }
            }
        }
}'
