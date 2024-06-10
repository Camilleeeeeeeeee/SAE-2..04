\echo telechargement du fichier csv 
\! wget -O parcoursup.csv "https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B"
\echo fichier telecharger 
DROP TABLE IF EXISTS import; 

\echo creation de la table en cours 
CREATE TABLE import(
    n1  integer default null,
    n2  Char(33)  default null,
    n3  Char(8) default null,
    n4  text default null,
    n5  Char(3) default null,
    n6  Char(24) default null,
    n7  text default null,
    n8  text default null,
    n9  text default null,
    n10  text default null,
    n11  text default null,
    n12  text default null,
    n13  text default null,
    n14  text default null,
    n15  text default null,
    n16  text default null,
    n17  text default null,
    n18  text default null,
    n19  text default null,
    n20  text default null,
    n21  text default null,
    n22  text default null,
    n23  text default null,
    n24  text default null,
    n25  text default null,
    n26  text default null,
    n27  text default null,
    n28  integer default null,
    n29  integer default null,
    n30  integer default null,
    n31  integer default null,
    n32  integer default null,
    n33  integer default null,
    n34  integer default null,
    n35  integer default null,
    n36  integer default null,
    n37  integer default null,
    n38  integer default null,
    n39  integer default null,
    n40  integer default null,
    n41  integer default null,
    n42  integer default null,
    n43  integer default null,
    n44  integer default null,
    n45  integer default null,
    n46  integer default null,
    n47  float default null,
    n48  integer default null,
    n49  integer default null,
    n50  integer default null,
    n51  float default null,
    n52  float default null,
    n53  float default null,
    n54  float default null,
    n55  float default null,
    n56  float default null,
    n57  float default null,
    n58  float default null,
    n59  float default null,
    n60  integer default null,
    n61  integer default null,
    n62  integer default null,
    n63  integer default null,
    n64  integer default null,
    n65  integer default null,
    n66  float default null,
    n67  integer default null,
    n68  float default null,
    n69  integer default null,
    n70  integer default null,
    n71  integer default null,
    n72  integer default null,
    n73  integer default null,
    n74  float default null,
    n75  float default null,
    n76  float default null,
    n77  float default null,
    n78  float default null,
    n79  float default null,
    n80  float default null,
    n81  float default null,
    n82  float default null,
    n83  float default null,
    n84  float default null,
    n85  float default null,
    n86  float default null,
    n87  float default null,
    n88  float default null,
    n89  float default null,
    n90  float default null,
    n91  float default null,
    n92  float default null,
    n93  float default null,
    n94  float default null,
    n95  float default null,
    n96  float default null,
    n97  float default null,
    n98  float default null,
    n99  float default null,
    n100  float default null,
    n101  float default null,
    n102  Char(39) default null,
    n103  float default null,
    n104  Char(39) default null,
    n105  integer default null,
    n106  Char(39) default null,
    n107  integer default null,
    n108  Char(45) default null,
    n109  Char(19) default null,
    n110  integer default null,
    n111  text default null,
    n112  text default null,
    n113  float default null,
    n114  float default null,
    n115  float default null,
    n116  float default null,
    n117  Char(5) default null,
    n118  Char(5) default null
);


\echo Table import cree 

select * from import; 

\echo importation du fichier dans la table

\copy import from parcoursup.csv with (format CSV, delimiter ';', HEADER);

\echo fichier importer

\echo ventilation 


DROP TABLE IF EXISTS regions CASCADE;
\echo creation de la table regions 
/* Création puis ajout de la clé primaire pour garder le type correspondant à import */
CREATE TABLE regions AS (SELECT DISTINCT n7 as nom FROM import);
ALTER TABLE regions ADD CONSTRAINT pk_regions_nom PRIMARY KEY(nom);

DROP TABLE IF EXISTS departements CASCADE;
\echo creation de la table departements 
/* Création puis ajout de la clé primaire et de la clé étrangère pour garder le type correspondant à import */
CREATE TABLE departements AS (SELECT DISTINCT n5 AS dno, n6 AS nom, n7 as region FROM import);
ALTER TABLE departements ADD CONSTRAINT pk_departements_dno PRIMARY KEY (dno);
ALTER TABLE departements ADD CONSTRAINT fk_departements_region FOREIGN KEY (region) REFERENCES regions (nom);

DROP TABLE IF EXISTS academies CASCADE;
\echo creation de la table academies 
/* Création puis ajout de la clé primaire pour garder le type correspondant à import */
CREATE TABLE academies AS (SELECT DISTINCT n8 as nom FROM import);
ALTER TABLE academies ADD CONSTRAINT pk_academies_nom PRIMARY KEY(nom);

DROP TABLE IF EXISTS etablissements CASCADE;
\echo creation de la table etablissements 
/* Création puis ajout de la clé primaire et de la clé étrangère pour garder le type correspondant à import */
CREATE TABLE etablissements AS (SELECT DISTINCT n3 as code, n4 as nom, n2 as statut, n5 AS departement FROM import);
ALTER TABLE etablissements ADD CONSTRAINT pk_etablissements_code PRIMARY KEY (code);
ALTER TABLE etablissements ADD CONSTRAINT fk_etablissements_departement FOREIGN KEY (departement) REFERENCES departements (dno);
/* On ne peut pas ajouter la ville car il y a des exemples d'établissements sur deux villes (ex: Lycée professionnel des Métiers Jean-Baptiste Clément (Sedan / Vivier-au-Court) */

DROP TABLE IF EXISTS formations CASCADE;
\echo creation de la table formations 
/* Création puis ajout de la clé primaire pour garder le type correspondant à import */
CREATE TABLE formations AS (SELECT DISTINCT n12 AS libelle, n15 AS type FROM import);
ALTER TABLE formations ADD CONSTRAINT pk_formations PRIMARY KEY (libelle, type);

DROP TABLE IF EXISTS effectifs CASCADE;
\echo creation de la table effectifs 
/* Création puis ajout de la clé primaire et de la clé étrangère pour garder le type correspondant à import */
CREATE TABLE effectifs AS (SELECT n3 AS etablissement, n12 AS libelle, n15 AS type, n18 AS capaciteAccueil, n19 AS totalCandidats, n20 AS nbCandidates, 24+26+28 AS nbCandidatsBoursiers, n47 AS totalAdmis, n48 AS nbAdmises, n51 AS nbAdmisPropositionRecueAvantOuverturePhasePrincipale, n53 AS nbAdmisPropositionRecueAvanFinPhasePrincipale, n54 AS nbAdmisInternat, n55 AS nbNeoBacBoursierAdmis, n57 AS nbNeoBacGeneral, n58 AS nbNeoBacTechno, n59 AS nbNeoBacPro FROM import);
ALTER TABLE effectifs ADD CONSTRAINT fk_effectifs_etablissement FOREIGN KEY (etablissement) REFERENCES etablissements (code);
ALTER TABLE effectifs ADD CONSTRAINT fk_effectifs_formation FOREIGN KEY (libelle, type) REFERENCES formations (libelle, type);

\echo fin de la ventilation 
