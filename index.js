'use strict';

const express = require('express');
// Constants
const PORT=9090;
const HOST='0.0.0.0';

//App
const app=express();
app.get('/', (req,res)=> { res.send('Hello from node-secrets.'); });
app.use('/data', express.static('/myAZFileShare', {
	setHeaders: (res, path, stat) => { res.set('Content-Type', 'text/plain'); }
}));

app.listen(PORT, HOST);

