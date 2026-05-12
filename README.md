# SenAgriculture - Guide de démarrage

## 🚀 DÉMARRAGE RAPIDE (EN 3 ÉTAPES)

### ⚠️ IMPORTANT : Ordre de démarrage obligatoire

**Vous DEVEZ démarrer les projets dans cet ordre :**

### Étape 1 : Préparer la base de données MySQL

1. **Démarrez XAMPP/WAMP** et assurez-vous que MySQL est actif
2. Ouvrez **phpMyAdmin** (http://localhost/phpmyadmin)
3. Cliquez sur **SQL** dans le menu du haut
4. **Copiez et collez** le contenu du fichier `Database_Setup.sql`
5. Cliquez sur **Exécuter**
6. ✅ Vérifiez que la base `senapiagriculture` et la table `produits` sont créées avec 5 produits

### Étape 2 : Démarrer le SERVICE WCF (OBLIGATOIRE EN PREMIER)

**Option A - Démarrage manuel (RECOMMANDÉ pour débuter) :**
1. Dans Visual Studio, dans l'**Explorateur de solutions**
2. **Cliquez droit** sur le projet `MetierAppSenagriculture`
3. Sélectionnez **Déboguer** > **Démarrer une nouvelle instance**
4. ⏳ **ATTENDEZ** qu'une page s'ouvre dans votre navigateur avec l'URL : `http://localhost:59843/Service1.svc`
5. ✅ Si vous voyez une page avec "Service1", le service fonctionne !
6. **⚠️ NE FERMEZ PAS cette fenêtre du navigateur** - laissez-la ouverte

**Option B - Démarrage automatique (Pour utilisateurs avancés) :**
1. Cliquez droit sur la **solution** (au-dessus de tous les projets)
2. Sélectionnez **Configurer les projets de démarrage...**
3. Choisissez **Projets de démarrage multiples**
4. Pour `MetierAppSenagriculture` : sélectionnez **Démarrer**
5. Pour `FrontSenAgriculture` : sélectionnez **Démarrer**
6. Cliquez **OK**
7. Appuyez sur **F5** - les deux projets démarreront ensemble

### Étape 3 : Démarrer l'APPLICATION CLIENTE

**Seulement APRÈS que le service WCF soit démarré :**

1. Dans Visual Studio, **cliquez droit** sur le projet `FrontSenAgriculture`
2. Sélectionnez **Déboguer** > **Démarrer une nouvelle instance**
3. ✅ L'application Windows Forms s'ouvre avec la liste des produits !

---

## 📋 Vérifications si ça ne fonctionne pas

### ❌ Problème : "Impossible de se connecter au service WCF"

**Cause :** Le service WCF n'est pas démarré ou n'est pas accessible

**Solutions :**
1. ✅ Vérifiez qu'une fenêtre de navigateur est ouverte avec `http://localhost:59843/Service1.svc`
2. ✅ Si non, redémarrez le projet `MetierAppSenagriculture`
3. ✅ Vérifiez que le port 59843 n'est pas utilisé par une autre application
4. ✅ Redémarrez Visual Studio en mode Administrateur

### ❌ Problème : "Délai d'attente dépassé" ou Timeout

**Cause :** MySQL n'est pas démarré ou la connexion est incorrecte

**Solutions :**
1. ✅ Ouvrez XAMPP/WAMP et vérifiez que MySQL est **vert/démarré**
2. ✅ Testez la connexion dans phpMyAdmin
3. ✅ Vérifiez le fichier `MetierAppSenagriculture\Web.config` :
   ```xml
   <connectionStrings>
       <add name="conn" 
            providerName="MySql.Data.MySqlClient" 
            connectionString="server=localhost;port=3306;database=senapiagriculture;user=root;password=root" />
   </connectionStrings>
   ```
4. ✅ Si votre mot de passe MySQL est différent, changez `password=root`

### ❌ Problème : DataGridView vide (aucun produit)

**Cause :** La table `produits` est vide ou n'existe pas

**Solutions :**
1. ✅ Dans phpMyAdmin, exécutez : `SELECT * FROM senapiagriculture.produits;`
2. ✅ Si aucun résultat, ré-exécutez le script `Database_Setup.sql`
3. ✅ Cliquez sur le bouton "Actualiser" dans l'application

---

## 🎯 Utilisation de l'application

### Affichage des produits
- ✅ Au démarrage, tous les produits s'affichent automatiquement dans le DataGridView
- ✅ Colonnes visibles : ID, Nom, Description, Prix Unitaire

### Ajouter un produit
1. **Libelle** : Saisissez le nom du produit (ex: "Mangue")
2. **Description** : Saisissez une description (ex: "Mangues fraîches du Sénégal")
3. **Prix Unitaire** : Saisissez le prix (ex: 750 ou 750.50)
4. Cliquez sur **Ajouter**
5. ✅ Un message de confirmation s'affiche
6. ✅ Le DataGridView se rafraîchit automatiquement
7. ✅ Les champs sont effacés pour un nouvel ajout

### Validation
- ❌ Les champs vides sont refusés
- ❌ Les prix négatifs ou invalides sont refusés
- ✅ Messages d'erreur explicites pour chaque problème

---

## 🔧 Configuration avancée

### Augmentation des timeouts (si problèmes de lenteur)

Les timeouts ont déjà été augmentés à **10 minutes** dans :
- `FrontSenAgriculture\App.config`
- `MetierAppSenagriculture\Web.config`

### Activer les détails d'erreurs (débogage)

Dans `MetierAppSenagriculture\Web.config` :
```xml
<serviceDebug includeExceptionDetailInFaults="true" />
```
✅ Déjà activé pour voir les erreurs détaillées

---

## 📂 Structure du projet

```
AppSenagriculture/
│
├── MetierAppSenagriculture/          # ⚙️ SERVICE WCF (À démarrer EN PREMIER)
│   ├── Service1.svc                   # Point d'entrée du service
│   ├── IService1.cs                   # Contrat du service
│   ├── Service1.svc.cs                # Implémentation
│   ├── Library/
│   │   ├── ProduitController.cs      # Logique métier (CRUD)
│   │   └── DiagnosticController.cs   # Diagnostics
│   ├── Model/
│   │   ├── Produit.cs                # Entité Produit
│   │   └── BdSenAgricultureContext.cs # Contexte Entity Framework
│   └── Web.config                     # ⚙️ Configuration service + BDD
│
├── FrontSenAgriculture/               # 🖥️ APPLICATION CLIENTE (À démarrer EN SECOND)
│   ├── Form1.cs                       # Interface utilisateur
│   ├── Form1.Designer.cs              # Design du formulaire
│   ├── Program.cs                     # Point d'entrée
│   └── App.config                     # ⚙️ Configuration client WCF
│
├── Database_Setup.sql                 # 📊 Script SQL de création
└── README.md                          # 📖 Ce fichier
```

---

## 🐛 Messages d'erreur détaillés

L'application affiche maintenant des messages d'erreur **très détaillés** pour vous aider :

### ✅ Message "Service WCF non démarré"
→ Démarrez `MetierAppSenagriculture` en premier

### ✅ Message "Délai d'attente dépassé"
→ Vérifiez que MySQL est démarré

### ✅ Message "Aucun produit trouvé"
→ Exécutez `Database_Setup.sql` pour créer des données de test

### ✅ Message "Erreur de communication"
→ Vérifiez l'URL du service dans `App.config`

---

## 📞 Commandes SQL utiles

### Voir tous les produits
```sql
SELECT * FROM senapiagriculture.produits;
```

### Ajouter un produit manuellement
```sql
INSERT INTO senapiagriculture.produits (NomProduit, DescriptionProduit, PrixUnitaire)
VALUES ('Banane', 'Bananes plantain', 600);
```

### Supprimer tous les produits
```sql
DELETE FROM senapiagriculture.produits;
```

### Réinitialiser l'auto-increment
```sql
ALTER TABLE senapiagriculture.produits AUTO_INCREMENT = 1;
```

---

## ✅ Checklist de démarrage

Avant de lancer l'application, vérifiez :

- [ ] MySQL est démarré (XAMPP/WAMP vert)
- [ ] La base `senapiagriculture` existe
- [ ] La table `produits` contient des données
- [ ] Le projet `MetierAppSenagriculture` est démarré
- [ ] Une page s'affiche à `http://localhost:59843/Service1.svc`
- [ ] Puis je démarre `FrontSenAgriculture`

---

## 🎓 Pour les étudiants

### Ce projet démontre :
- ✅ Architecture 3 tiers (Présentation / Métier / Données)
- ✅ Service WCF (Windows Communication Foundation)
- ✅ Entity Framework 6 avec MySQL
- ✅ Windows Forms avec DataGridView
- ✅ Pattern Controller pour la logique métier
- ✅ Gestion d'erreurs et validation

### Technologies utilisées :
- .NET Framework 4.7.2
- WCF (Service SOAP)
- Entity Framework 6
- MySQL 8.0
- Windows Forms

---

## 🆘 Support

Si vous rencontrez toujours des problèmes après avoir suivi ce guide :

1. ✅ Vérifiez les **logs** dans Visual Studio (Fenêtre Sortie)
2. ✅ Consultez le **débogueur** pour voir les exceptions
3. ✅ Testez la **connexion MySQL** dans phpMyAdmin
4. ✅ Vérifiez que le **port 59843** est libre

---

**✨ Bon développement ! ✨**
