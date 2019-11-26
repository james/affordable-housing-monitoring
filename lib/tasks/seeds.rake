task reseed: :environment do
  AffordableHousingAudit.delete_all
  Dwelling.delete_all
  PlanningApplication.delete_all
  Development.delete_all
  RegisteredProvider.delete_all
  User.delete_all
  Rake::Task['db:seed'].invoke
end
