# "Square Access Token"   - 0b1b2482-51e7-49d1-893d-522afa4a6bd0                                     positive-test   - #1
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Square Access Token"    allow-rule-test - #2
# "Picatic API Key"       - 50cc5f03-e686-4183-97e9-12f9b55d0f97                                     positive-test   - #3
# "Amazon MWS Auth Token" - ac8c8075-6ec0-4367-9e26-30ec8161d258                                     positive-test   - #4
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Amazon MWS Auth Token"  allow-rule-test - #5 (also detected as TF resource access)
# "MailChimp API Key"     - 6c54f9da-1a11-445a-8568-0d327e6af8be                                     positive-test   - #6
# "SendGrid API Key"      - 8a879bc7-6f82-40fd-bb48-74d25d557fe8                                     positive-test   - #7
FROM baseImage

#1 & #2:
ARG token=sq0atp-812erere3wewew45678901

#3:
ARG picaticKey=sk_live_123as6789o1234567890123a123a5678

#4 & #5:
ARG amazonToken=amzn.mws.643a5678-8f9f-1a2b-5c3b-e3ea43f3f4b4

#6:
ARG mailChimp=f4f56af5a54a3eaeb3c3beb3cc2ccccc-us36

#7:
ARG sgApiK=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
