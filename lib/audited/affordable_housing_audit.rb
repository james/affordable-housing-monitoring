class AffordableHousingAudit < Audited::Audit
  belongs_to :planning_application, optional: true
end
