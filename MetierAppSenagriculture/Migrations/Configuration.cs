using System.Data.Entity.Migrations;
using MetierAppSenagriculture.Model;
using MySql.Data.EntityFramework;

namespace MetierAppSenagriculture.Migrations
{
    internal sealed class Configuration : DbMigrationsConfiguration<BdSenAgricultureContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
            AutomaticMigrationDataLossAllowed= true;
            SetSqlGenerator("MySql.Data.MySqlClient", new MySqlMigrationSqlGenerator());
        }

        protected override void Seed(BdSenAgricultureContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method
            //  to avoid creating duplicate seed data.
        }
    }
}
