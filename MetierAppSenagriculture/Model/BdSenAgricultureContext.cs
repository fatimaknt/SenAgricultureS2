using System.Data.Entity;
using MySql.Data.MySqlClient;
using System;

namespace MetierAppSenagriculture.Model
{

        public class BdSenAgricultureContext : DbContext
        {
            public BdSenAgricultureContext() : base("conn")
            {
                // Désactiver le proxy et lazy loading pour WCF
                this.Configuration.ProxyCreationEnabled = false;
                this.Configuration.LazyLoadingEnabled = false;

                // Activer les logs SQL pour debug
                this.Database.Log = sql => System.Diagnostics.Debug.WriteLine($"SQL: {sql}");
            }

            protected override void OnModelCreating(DbModelBuilder modelBuilder)
            {
                base.OnModelCreating(modelBuilder);

                // Forcer les noms de table et colonnes en minuscules
                modelBuilder.Entity<Produit>()
                    .ToTable("produits");
            }

            public DbSet<Produit> Produits { get; set; }
        }
    }


