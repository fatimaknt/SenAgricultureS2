using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace MetierAppSenagriculture.Model
{
    [DataContract]
    [Table("produits")]
    public class Produit
    {
        [Key]
        [DataMember]
        [Column("idProduit")]
        public int idProduit { get; set; }

        [Required, MaxLength(100)]
        [DataMember]
        [Column("NomProduit")]
        public string NomProduit { get; set; }

        [Required, MaxLength(100)]
        [DataMember]
        [Column("DescriptionProduit")]
        public string DescriptionProduit { get; set; }

        [Required]
        [DataMember]
        [Column("PrixUnitaire")]
        public float? PrixUnitaire { get; set; }
    }

}