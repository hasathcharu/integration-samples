A(["Begin"]):::startNode
B["Fetch Issue Details from GitHub"]:::processNode
C["Send Email"]:::processNode
D(["Complete"]):::endNode

A --> B --> C --> D