/* Q1. Ecrire une requête qui, à partir de import affiche le contenu de la colonne n56 et le re-calcul de celle-ci à partir d’autres colonnes de import (2 cols). */
\echo recalcule de n56
SELECT n56, n57+n58+n59 AS recalcul FROM import LIMIT 10;

/* Q2. Quelle requête vous permet de savoir que ce re-calcul est parfaitement exact ? */
SELECT COUNT(*) AS nbErreurs FROM import WHERE n56 <> n57+n58+n59 LIMIT 10;
/* Le résultat de la requête est 0, donc il n'y a aucune ligne où il y a une différence entre la colonne n56 et son recalcul */

/* Q3. Ecrire une requête qui, à partir de import affiche le contenu de la colonne n74 et le re-calcul de celle-ci à partir d’autres colonnes de import (2 cols). */
\echo recalcule de n74
SELECT n74, ROUND(n51/NULLIF(n47, 0)*100) AS recalcul FROM import LIMIT 10;

/* Q4. Quelle requête vous permet de savoir+ que ce re-calcul est parfaitement exact ? */
\echo verification ( affichages des differences entre les deux colonnes): 
SELECT COUNT(*) AS nbErreurs FROM import WHERE n74 <> ROUND(n51/NULLIF(n47, 0)*100) LIMIT 10;
/* On voit que 3 lignes sont en erreur. Essayons de comprendre pourquoi */
SELECT n74, n51/NULLIF(n47, 0)*100 AS recalcul FROM import WHERE n74 <> ROUND(n51/NULLIF(n47, 0)*100) LIMIT 10;
/* On constate que les valeurs sont presque bonnes, on trouve 57.49999999999... C'est donc lors du calcul qe le problème se passe. */
SELECT n74, n51/NULLIF(n47, 0) AS recalcul FROM import WHERE n74 <> ROUND(n51/NULLIF(n47, 0)*100) LIMIT 10;
/* Ici, pas d'erreur. C'est donc quand on multiplie par 100 que le calcul se passe mal. Postgres a sûrement du mal avec les petits nombre, on va donc essayer de multiplier d'abord par 100 pour qu'il travaille avec de "grands" nombres (>0) */
SELECT COUNT(*) AS nbErreurs FROM import WHERE n74 <> ROUND(100*n51/NULLIF(n47, 0)) LIMIT 10;
/* Aucune erreur ! */

/* Q5. Ecrire une requête qui, à partir de import affiche le contenu de la colonne n76 et le re-calcul de celle-ci à partir d’autres colonnes de import (2 cols). A partir de combien de décimales ces données sont exactes ? */
\echo recalcule de n76 : 
SELECT n76, ROUND(100*n53/NULLIF(n47, 0)) AS recalcul FROM import LIMIT 10;
\echo verification ( affichages des differences entre les deux colonnes): 
SELECT COUNT(*) AS recalcul FROM import WHERE n76 <> ROUND(100*n53/NULLIF(n47, 0)) LIMIT 10;
/* 0 lignes, la requête est donc exacte */

/* Q6. Fournir la même requête sur vos tables ventilées */
\echo requete sur table ventiler  : 
SELECT ROUND(100*nbAdmisPropositionRecueAvanFinPhasePrincipale / NULLIF(totalAdmis, 0)) AS n76 FROM effectifs LIMIT 10;

/* Q7. Ecrire une requête qui, à partir de import affiche la n81 et la manière de la recalculer. A partir de combien de décimales ces données sont exactes ? */
\echo recalcul n81  
SELECT n81, ROUND(100*n55/NULLIF(n56, 0)) AS recalcul FROM import LIMIT 10;
\echo verification ( affichages des differences entre les deux colonnes): 
SELECT COUNT(*) AS recalcul FROM import WHERE n81 <> ROUND(100*n55/NULLIF(n56, 0)) LIMIT 10;
/* 0 lignes, la requête est donc exacte */

/* Q8. Fournir la même requête sur vos tab+les ventilées */
\echo meme requete sur table ventiler  : 
SELECT ROUND(100*nbNeoBacBoursierAdmis/NULLIF((nbNeoBacGeneral+nbNeoBacTechno+nbNeoBacPro), 0)) AS n81 FROM effectifs LIMIT 10;
