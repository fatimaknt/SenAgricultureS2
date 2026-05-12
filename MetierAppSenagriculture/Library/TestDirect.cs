using System;
using System.Linq;
using MetierAppSenagriculture.Model;

namespace MetierAppSenagriculture.Library
{
    public class TestDirect
    {
        public static string TestEFConnection()
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    bd.Configuration.ProxyCreationEnabled = false;
                    bd.Configuration.LazyLoadingEnabled = false;

                    // Test de connexion
                    var canConnect = bd.Database.Exists();
                    if (!canConnect)
                    {
                        return "ERREUR: Base de donnees n'existe pas";
                    }

                    // Compter avec SQL
                    var sqlCount = bd.Database.SqlQuery<int>("SELECT COUNT(*) FROM produits").FirstOrDefault();

                    // Compter avec EF
                    var efCount = bd.Produits.Count();

                    // Récupérer les produits
                    var produits = bd.Produits.ToList();

                    var result = $"SQL COUNT: {sqlCount}\n";
                    result += $"EF COUNT: {efCount}\n";
                    result += $"Liste Count: {produits.Count}\n\n";

                    if (produits.Count > 0)
                    {
                        result += "Premiers produits:\n";
                        foreach (var p in produits.Take(3))
                        {
                            result += $"  ID={p.idProduit}, Nom={p.NomProduit}, Prix={p.PrixUnitaire}\n";
                        }
                    }

                    return result;
                }
            }
            catch (Exception ex)
            {
                return $"ERREUR: {ex.Message}\n\nStackTrace:\n{ex.StackTrace}";
            }
        }
    }
}
