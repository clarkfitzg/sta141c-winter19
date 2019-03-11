SELECT award_id, awarding_agency_id, funding_amount
FROM `transaction`
WHERE 0 < funding_amount
LIMIT 10
;