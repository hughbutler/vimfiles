json.meeting_id @meeting.id
json.person_id @attendance.person.id
json.attended @attendance.persisted?
