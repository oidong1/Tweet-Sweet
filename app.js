var RedisStore, app, express, oauth;

express = require("express");

oauth = new (require("oauth").OAuth)("https://api.twitter.com/oauth/request_token", "https://api.twitter.com/oauth/access_token", "token", "token-secret", "1.0", "http://localhost:3100/auth/twitter/callback", "HMAC-SHA1");

RedisStore = require('connect-redis')(express);

app = module.exports = express.createServer();

app.configure(function() {
  app.register('.coffee', require('coffeekup'));
  app.set("views", __dirname + "/views");
  app.set("view engine", "coffeekup");
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({
    secret: "secret",
    store: new RedisStore(),
    cookie: {
      maxAge: 7 * 24 * 60 * 60 * 1000
    }
  }));
  app.use(app.router);
  return app.use(express.static(__dirname + "/public"));
});

app.configure("development", function() {
  return app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});

app.configure("production", function() {
  return app.use(express.errorHandler());
});

app.dynamicHelpers({
  session: function(req, res) {
    return req.session;
  }
});

app.get("/", function(req, res) {
  return res.render('index.coffee');
});

app.post('/', function(req, res) {
  if (req.session.oauth) {
    return oauth.getProtectedResource("http://api.twitter.com/1/statuses/user_timeline/" + req.body.screen_name + ".json", "GET", req.session.oauth.access_token, req.session.access_token_secret, function(error, data, response) {
      var contents;
      if (error) {
        return res.render('index.coffee', {
          id: req.body.screen_name,
          content: 404
        });
      } else {
        contents = '';
        data = JSON.parse(data);
        return res.render('index.coffee', {
          id: req.body.screen_name,
          content: data
        });
      }
    });
  }
});

app.get("/auth/twitter", function(req, res) {
  return oauth.getOAuthRequestToken(function(error, oauth_token, oauth_token_secret, results) {
    if (error) {
      return res.send(error);
    } else {
      req.session.oauth = {};
      req.session.oauth.token = oauth_token;
      req.session.oauth.token_secret = oauth_token_secret;
      return res.redirect("https://twitter.com/oauth/authenticate?oauth_token=" + oauth_token);
    }
  });
});

app.get("/auth/twitter/callback", function(req, res) {
  if (req.session.oauth) {
    req.session.oauth.verifier = req.query.oauth_verifier;
    return oauth.getOAuthAccessToken(req.session.oauth.token, req.session.oauth.token_secret, req.session.oauth.verifier, function(error, oauth_access_token, oauth_access_token_secret, results) {
      if (error) {
        return res.send(error);
      } else {
        req.session.oauth.access_token = oauth_access_token;
        req.session.oauth.access_token_secret = oauth_access_token_secret;
        req.session.user_profile = results;
        return res.redirect('/');
      }
    });
  }
});

app.get("/signout", function(req, res) {
  delete req.session.oauth;
  delete req.session.user_profile;
  return res.redirect("/");
});

app.error(function(err, res) {
  return res.send(err.message, 500);
});

app.listen(3100);

console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);