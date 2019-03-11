SELECT award_id, awarding_agency_id, funding_amount
FROM `transaction` as t
JOIN agency as a ON t.funding_agency_id = a.toptier_agency_id
LIMIT 10
;