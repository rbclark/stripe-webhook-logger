# Stripe Webhook Logger

Stripe doesn't provide example responses from their webhook API on their documentation site. The only way to get examples is by requesting the data using the stripe package locally. This small web application provides a way to listen to responses from the Stripe API, anonymize them, and log them to disk for future use. The intent of this is to provide an easy way for [stripe-ruby-mock](https://github.com/stripe-ruby-mock/stripe-ruby-mock) to update its webhook fixture data without requiring manual anonymization.

### How to Use

First you will need to start this application locally, it can be done with two easy steps:

    bundle install
    bundle exec ruby run.rb

Next, in a separate terminal window you need to setup a stripe listener to forward to your local machine.

    stripe listen --forward-to localhost:4567/webhook

Once a listener is running, in another separate terminal window you can trigger different events, for example:

    stripe trigger invoice.payment_action_required

Note that each action you trigger will trigger multiple related webhooks as well. The anonymized result will then be written to the `webhooks` folder.

To list all available webhook actions run

    stripe trigger --help
