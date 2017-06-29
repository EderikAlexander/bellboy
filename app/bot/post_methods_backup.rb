# ########################################################################################################################
# #################                              WHITELISTING URL                                       ##################
# ########################################################################################################################

# # READING

# curl -X GET "https://graph.facebook.com/v2.6/me/messenger_profile?fields=whitelisted_domains&access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"


# # ADDING

# curl -X POST -H "Content-Type: application/json" -d '{
#   "whitelisted_domains":[
#     "https://bellboy-app.herokuapp.com/", "https://www.facebook.com", "https://bellboy3.fwd.wf/"
#   ]
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"


# ########################################################################################################################
# ##################                              GREETING TEXT                                       ####################
# ########################################################################################################################

# # ADD

# curl -X POST -H "Content-Type: application/json" -d '{
#   "greeting":[
#     {
#       "locale":"default",
#       "text":"Take your concierge hotel in your pocket.
#       Here are some questions that you can ask,
#       - Who are you?
#       - What is the wifi password?
#       - What can I do around here?
#       - What time is my massage?
#       - List my service bookings
#       "
#     }, {
#       "locale":"eu_ES",
#       "text":"Take your concierge hotel in your pocket.
#       Here are some questions that you can ask,
#       - Who are you?
#       - What is the wifi password?
#       - What can I do around here?
#       - What time is my massage?
#       - List my service bookings
#       "
#     }
#   ]
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"


# # DELETE

# curl -X DELETE -H "Content-Type: application/json" -d '{
#   "setting_type":"greeting"
# }' "https://graph.facebook.com/v2.6/me/thread_settings?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"




# #########################################################################################################################
# ###################                              GET STARTED                                       ######################
# #########################################################################################################################

# # ADD

# curl -X POST -H "Content-Type: application/json" -d '{
#   "get_started":{
#     "payload":"GET_STARTED_PAYLOAD"
#   }
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"


# # DELETE

# curl -X DELETE -H "Content-Type: application/json" -d '{
#   "fields":[
#     "get_started"
#   ]
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"





# #########################################################################################################################
# #################                              PERSISTENT MENU                                       ####################
# #########################################################################################################################

# # # ADD

# curl -X POST -H "Content-Type: application/json" -d '{
#   "persistent_menu":[
#     {
#       "locale":"default",
#       "composer_input_disabled":false,
#       "call_to_actions":[
#         {
#         "type":"postback",
#         "title":"General questions",
#         "payload":"KEEP_CHATTING_PAYLOAD"
#         },
#         {"type":"web_url",
#         "title":"Back to App",
#         "url":"https://bellboy-app.herokuapp.com",
#         "webview_height_ratio":"full",
#         "messenger_extensions":true,
#         "fallback_url":"https://bellboy-app.herokuapp.com"}
#       ]
#     }
#    ]
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"


# # # DELETE - First step if you want a new menu/added menu

# curl -X DELETE -H "Content-Type: application/json" -d '{
#   "fields":[
#     "persistent_menu"
#   ]
# }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=EAAL09FQZA8ncBAPCbZCiM3O4LGt2ZA9bx361hO7v0WZBkiNxR34iZC1tYBWXsmrZCf03ZCrBbjFK8oslq7Kn82LH3r4Bt5hWKBGZC9J1on8Si1rY1epMKb3ZCSDpYi6ZBupgwwcEMJv1zwGL26oLZAxVBWsXImysjvP5UCnAw2jM9CmHg8FgBTfcl7cnhZBWazO9eXkZD"
