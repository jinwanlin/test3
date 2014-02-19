json.status @phone_can_use & @is_send_validate_code ? 0 : -1
json.phone_can_use @phone_can_use
json.is_send_validate_code @is_send_validate_code
json.message @message
p @message
