namespace MetierAppSenagriculture.Model
{
    [DbConfigurationType(typeof(MySql.Data.Entity.MySqlEFConfiguration))]
    public class BdSenAgricultureContext: DbContext
    {
        public BdSenAgricultureContext(): base("conn");
        public DbSet<Produit> Produits { get; set; }
    }
}