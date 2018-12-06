# Create a hosted graphite, and configure the app to use it
# Code taken from exam paper and expanded upon
resource "heroku_addon" "hostedgraphite_ci" {
  app  = "${heroku_app.ci.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "hostedgraphite_stage" {
  app  = "${heroku_app.staging.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "hostedgraphite_production" {
  app  = "${heroku_app.production.name}"
  plan = "hostedgraphite"
}