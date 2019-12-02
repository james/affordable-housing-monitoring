require Rails.root.join('lib', 'audited', 'affordable_housing_audit')

Audited.config do |config|
  config.audit_class = AffordableHousingAudit
end
