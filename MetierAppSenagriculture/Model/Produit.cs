using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MetierAppSenagriculture.Model
{
    [Key]
    public int IdProduit { get; set; }
    [Required, MaxLength(100)]
    public string NomProduit { get; set; }
     [Required, MaxLength(100)]
    public string DescriptionProduit { get; set; }
  [Required]
   public float? PrixUnitaire { get; set; }
   

}