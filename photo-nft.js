// Node.js application to host the frontend
//
const express = require('express');
const formidable = require('formidable');
const fs = require('fs');
const exec = require('child_process').exec;

const port = 34000;

const app = express();
const rte = express.Router();

app.set('port', port);

// static content

app.get('/', function (req, res){
   console.log('.');
   res.setHeader("Content-Type", "text/html");
   res.write("<p>Fabric NFT Endpoint</p>");
   res.end();
});

app.get('/w3.css', function (req, res) {
   res.sendFile(__dirname + '/html/w3.css');
});
app.get('/photo', function (req, res) {
   res.sendFile(__dirname + '/html/index-photo.html');
});
app.get('/licensing', function (req, res) {
   res.sendFile(__dirname + '/html/index-license.html');
});
app.get('/photo/identity/result', function (req, res) {
   res.sendFile(__dirname + '/html/identity-create.html');
});
app.get('/photo/nft/create/prepare', function (req, res) {
   res.sendFile(__dirname + '/html/copyright-nft-prepare.html');
});
app.get('/photo/nft/create/result', function (req, res) {
   res.sendFile(__dirname + '/html/copyright-nft-create.html');
});
app.get('/photo/nft/balance/result', function (req, res) {
   res.sendFile(__dirname + '/html/copyright-nft-balance.html');
});
app.get('/photo/nft/owner/result', function (req, res) {
   res.sendFile(__dirname + '/html/copyright-nft-owner.html');
});
app.get('/photo/nft/transfer/result', function (req, res) {
   res.sendFile(__dirname + '/html/copyright-nft-transfer.html');
});
app.get('/license/token/create/result', function (req, res) {
   res.sendFile(__dirname + '/html/license-token-create.html');
});
app.get('/license/token/balance/result', function (req, res) {
   res.sendFile(__dirname + '/html/license-token-balance.html');
});
app.get('/license/token/transfer/result', function (req, res) {
   res.sendFile(__dirname + '/html/license-token-transfer.html');
});

// functions

app.get('/photo/identity/create', (req, res, next) => {
   console.log("Create Identity ...");
   let otPeerID = req.query.peerID;
   let resp = exec("bash control/identity-create.sh \"" + otPeerID + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/photo/identity/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});

app.post('/photo/nft/upload', (req, res) => {
   console.log("Upload ...");
   let form = new formidable.IncomingForm();
   form.parse(req);
   form.on('fileBegin', function (name, file) {
      if (file.name.length < 1) {
         res.status(204).send();
         return;
      }
      file.path = __dirname + '/uploads/' + file.name;
   });
   form.on('file', function (name, file){
      if (file.name.length < 1) {
         return;
      }
      console.log('Uploaded ' + file.name);
      console.log('Calculate token ID ...');
      let resp = exec("bash control/sha256.sh " + file.path, function(err, stdout, stderr) {
         console.log('ID ' + stdout);
         //res.status(204).send();
         res.redirect('/photo/nft/create/prepare' +
            '?ot-token-id=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
         );
      });
   });
});

app.get('/photo/nft/create', (req, res, next) => {
   console.log("Create NFT ...");
   let otTokenID = req.query.otTokenID;
   let otURI = req.query.otURI;
   let resp = exec("bash control/copyright-nft-create.sh \"" + otTokenID + "\" \"" + otURI + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/photo/nft/create/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});

app.get('/photo/nft/balance', (req, res, next) => {
   console.log("NFT balance ...");
   let otPeerID = req.query.peerID;
   let resp = exec("bash control/copyright-nft-balance.sh \"" + otPeerID + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/photo/nft/balance/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});


app.get('/photo/nft/owner', (req, res, next) => {
   console.log("NFT owner ...");
   let otPeerID = req.query.peerID;
   let otTokenID = req.query.tokenID;
   let resp = exec("bash control/copyright-nft-owner.sh \"" + otPeerID + "\" \"" + otTokenID + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/photo/nft/owner/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});


app.get('/photo/nft/transfer', (req, res, next) => {
   console.log("Transfer NFT ...");
   let otTokenID = req.query.tokenID;
   let otPeerIDS = req.query.peerIDS;
   let otPeerIDR = req.query.peerIDR;
   let resp = exec("bash control/copyright-nft-transfer.sh \"" + otTokenID + "\" \"" + otPeerIDS + "\" \"" + otPeerIDR + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/photo/nft/transfer/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});

app.get('/license/token/create', (req, res, next) => {
   console.log("Create license token ...");
   let ltTokenID = req.query.tokenID;
   let ltQuantity = req.query.quantity;
   let resp = exec("bash control/license-token-create.sh \"" + ltQuantity + "\" \"" + ltTokenID + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/license/token/create/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});


app.get('/license/token/balance', (req, res, next) => {
   console.log("Token balance ...");
   let ltPeerID = req.query.peerID;
   let resp = exec("bash control/license-token-balance.sh \"" + ltPeerID + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/license/token/balance/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});


app.get('/license/token/transfer', (req, res, next) => {
   console.log("Transfer license token ...");
   let ltQuantity = req.query.quantity;
   let ltPeerIDS = req.query.peerIDS;
   let ltPeerIDR = req.query.peerIDR;
   let resp = exec("bash control/license-token-transfer.sh \"" + ltQuantity + "\" \"" + ltPeerIDS + "\" \"" + ltPeerIDR + "\"", function(err, stdout, stderr) {
      console.log(stdout);
      //res.status(204).send();
      res.redirect('/license/token/transfer/result' +
         '?res=' + encodeURIComponent(stdout) + encodeURIComponent(stderr)
      );
   });
});

// initialize

app.use((req, res, next) => {
    return res.status(404).send();
});


app.listen(port, () => {
   console.log('Listening on port ' + port);
});

