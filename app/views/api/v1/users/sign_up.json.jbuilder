json.status @phone_can_use & @is_send_validate_code ? 0 : -1
json.message @message
p @message

json.phone_can_use @phone_can_use
json.is_send_validate_code @is_send_validate_code
