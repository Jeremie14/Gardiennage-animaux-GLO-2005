-- =========================================================
-- Fichier : requetes_routines_pet_sitting.sql
-- Projet : Service de pet sitting
-- Objet  : Requêtes avancées et routines SQL
-- Auteurs: Meriem Ben Temime, Lyne Ghazala, Aymen Ben Alaya, Jérémie Pelletier
-- SGBD   : MySQL 8.2

-- =========================================================
-- SECTION 1 - REQUÊTES
-- =========================================================

-- ---------------------------------------------------------
-- Requête 1
-- Trouver les GardienAnimauxs disponibles pour une période donnée
-- et pour un type de service précis.
-- Utilise :
-- - jointures explicites
-- - sous-requête
-- - filtrage temporel
-- ---------------------------------------------------------
SELECT
    G.idGardienAnimaux,
    U.prenom,
    U.nom,
    G.zoneService,
    S.typeService,
    S.tarif
FROM GardienAnimaux G
JOIN Utilisateur U
    ON U.idUtilisateur = G.idUtilisateur
JOIN Service S
    ON S.idGardienAnimauxAnimaux = G.idGardienAnimauxAnimaux
JOIN Disponibilite D
    ON D.idGardienAnimauxAnimaux = G.idGardienAnimauxAnimaux
WHERE G.actif = TRUE
  AND S.typeService = 'GARDE_JOUR'
  AND D.statut = 'DISPONIBLE'
  AND D.dateDebut <= '2026-05-10'
  AND D.dateFin >= '2026-05-12'
  AND G.idGardienAnimaux NOT IN (
        SELECT DR.idGardienAnimaux
        FROM DemandeReservation DR
        JOIN Reservation R
            ON R.idDemande = DR.idDemande
        WHERE R.statut IN ('CONFIRMEE', 'EN_COURS')
          AND DR.dateDebut <= '2026-05-12'
          AND DR.dateFin >= '2026-05-10'
  );


-- ---------------------------------------------------------
-- Requête 2
-- Calculer la moyenne des notes et le nombre d'avis par GardienAnimaux.
-- Utilise :
-- - agrégation
-- - jointure externe
-- - tri
-- ---------------------------------------------------------
SELECT
    G.idGardienAnimaux,
    U.prenom,
    U.nom,
    ROUND(AVG(A.note), 2) AS noteMoyenne,
    COUNT(A.idAvis) AS nombreAvis
FROM GardienAnimaux G
JOIN Utilisateur U
    ON U.idUtilisateur = G.idUtilisateur
LEFT JOIN Avis A
    ON A.idGardienAnimaux = G.idGardienAnimaux
GROUP BY G.idGardienAnimaux, U.prenom, U.nom
ORDER BY noteMoyenne DESC, nombreAvis DESC;


-- ---------------------------------------------------------
-- Requête 3
-- Calculer le revenu total généré par chaque GardienAnimaux.
-- Utilise :
-- - agrégation
-- - COALESCE
-- - jointures multiples
-- ---------------------------------------------------------
SELECT
    G.idGardienAnimaux,
    U.prenom,
    U.nom,
    COUNT(R.idReservation) AS nbReservations,
    COALESCE(SUM(R.prixTotal), 0) AS revenuTotal
FROM GardienAnimaux G
JOIN Utilisateur U
    ON U.idUtilisateur = G.idUtilisateur
LEFT JOIN DemandeReservation DR
    ON DR.idGardienAnimaux = G.idGardienAnimaux
LEFT JOIN Reservation R
    ON R.idDemande = DR.idDemande
   AND R.statut IN ('CONFIRMEE', 'EN_COURS', 'TERMINEE')
GROUP BY G.idGardienAnimaux, U.prenom, U.nom
ORDER BY revenuTotal DESC;


-- ---------------------------------------------------------
-- Requête 4
-- Trouver les propriétaires ayant dépensé plus que la moyenne
-- des propriétaires.
-- Utilise :
-- - sous-requête imbriquée
-- - HAVING
-- - agrégation
-- ---------------------------------------------------------
SELECT
    U.idUtilisateur,
    U.prenom,
    U.nom,
    SUM(R.prixTotal) AS totalDepense
FROM Utilisateur U
JOIN DemandeReservation DR
    ON DR.idProprietaire = U.idUtilisateur
JOIN Reservation R
    ON R.idDemande = DR.idDemande
WHERE R.statut IN ('CONFIRMEE', 'EN_COURS', 'TERMINEE')
GROUP BY U.idUtilisateur, U.prenom, U.nom
HAVING SUM(R.prixTotal) > (
    SELECT AVG(total_client)
    FROM (
        SELECT SUM(R2.prixTotal) AS total_client
        FROM DemandeReservation DR2
        JOIN Reservation R2
            ON R2.idDemande = DR2.idDemande
        WHERE R2.statut IN ('CONFIRMEE', 'EN_COURS', 'TERMINEE')
        GROUP BY DR2.idProprietaire
    ) AS depenses
);


-- ---------------------------------------------------------
-- Requête 5
-- Top 5 des GardienAnimauxs les mieux notés avec au moins 3 avis.
-- Utilise :
-- - agrégation
-- - HAVING
-- - LIMIT
-- ---------------------------------------------------------
SELECT
    G.idGardienAnimaux,
    U.prenom,
    U.nom,
    ROUND(AVG(A.note), 2) AS noteMoyenne,
    COUNT(A.idAvis) AS nbAvis
FROM GardienAnimaux G
JOIN Utilisateur U
    ON U.idUtilisateur = G.idUtilisateur
JOIN Avis A
    ON A.idGardienAnimaux = G.idGardienAnimaux
GROUP BY G.idGardienAnimaux, U.prenom, U.nom
HAVING COUNT(A.idAvis) >= 3
ORDER BY noteMoyenne DESC, nbAvis DESC
LIMIT 5;


-- ---------------------------------------------------------
-- Requête 6
-- Afficher les réservations à venir d'un propriétaire donné.
-- Utilise :
-- - jointures explicites
-- - filtre temporel
-- - tri
-- ---------------------------------------------------------
SELECT
    R.idReservation,
    A.nom AS nomAnimal,
    U2.prenom AS prenomGardienAnimaux,
    U2.nom AS nomGardienAnimaux,
    DR.dateDebut,
    DR.dateFin,
    R.statut,
    R.prixTotal
FROM Reservation R
JOIN DemandeReservation DR
    ON DR.idDemande = R.idDemande
JOIN Animal A
    ON A.idAnimal = DR.idAnimal
JOIN GardienAnimaux G
    ON G.idGardienAnimaux = DR.idGardienAnimaux
JOIN Utilisateur U2
    ON U2.idUtilisateur = G.idUtilisateur
WHERE DR.idProprietaire = 1
  AND DR.dateDebut >= CURDATE()
ORDER BY DR.dateDebut;


-- =========================================================
-- SECTION 2 - FONCTION SQL
-- =========================================================

-- ---------------------------------------------------------
-- Fonction : CalculerNoteMoyenneGardienAnimaux
-- But :
-- Retourner la note moyenne d'un GardienAnimaux à partir de la table Avis.
-- Si le GardienAnimaux n'a aucun avis, la fonction retourne 0.00.
-- ---------------------------------------------------------

DROP FUNCTION IF EXISTS CalculerNoteMoyenneGardienAnimaux;
DELIMITER //

CREATE FUNCTION CalculerNoteMoyenneGardienAnimaux(p_idGardienAnimaux INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
    DECLARE v_note_moyenne DECIMAL(4,2);

    SELECT ROUND(AVG(note), 2)
    INTO v_note_moyenne
    FROM Avis
    WHERE idGardienAnimaux = p_idGardienAnimaux;

    RETURN COALESCE(v_note_moyenne, 0.00);
END //

DELIMITER ;


-- =========================================================
-- SECTION 3 - PROCÉDURES STOCKÉES
-- =========================================================

-- ---------------------------------------------------------
-- Procédure 1 : AccepterDemandeEtCreerReservation
--
-- But :
-- 1) vérifier que la demande existe
-- 2) vérifier que son statut est EN_ATTENTE
-- 3) vérifier la validité des dates
-- 4) vérifier l'absence de conflit de réservation
-- 5) calculer le prix total
-- 6) mettre à jour la demande
-- 7) créer la réservation
-- 8) créer le paiement
--
-- Cette procédure automatise un vrai traitement métier complexe.
-- ---------------------------------------------------------

DROP PROCEDURE IF EXISTS AccepterDemandeEtCreerReservation;
DELIMITER //

CREATE PROCEDURE AccepterDemandeEtCreerReservation(
    IN p_idDemande INT,
    IN p_methodePaiement VARCHAR(20)
)
BEGIN
    DECLARE v_idGardienAnimaux INT;
    DECLARE v_dateDebut DATE;
    DECLARE v_dateFin DATE;
    DECLARE v_tarif DECIMAL(8,2);
    DECLARE v_nbJours INT;
    DECLARE v_prixTotal DECIMAL(8,2);
    DECLARE v_statutDemande VARCHAR(20);
    DECLARE v_conflits INT DEFAULT 0;
    DECLARE v_idReservation INT;

    -- Gestion des erreurs SQL générales
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur SQL pendant la création de la réservation.';
    END;

    START TRANSACTION;

    -- Récupération des informations de la demande et du tarif du service
    SELECT
        DR.idGardienAnimaux,
        DR.dateDebut,
        DR.dateFin,
        DR.statut,
        S.tarif
    INTO
        v_idGardienAnimaux,
        v_dateDebut,
        v_dateFin,
        v_statutDemande,
        v_tarif
    FROM DemandeReservation DR
    JOIN Service S
        ON S.idService = DR.idService
    WHERE DR.idDemande = p_idDemande;

    -- Vérification de l'existence de la demande
    IF v_statutDemande IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La demande n''existe pas.';
    END IF;

    -- Vérifier que la demande est bien en attente
    IF v_statutDemande <> 'EN_ATTENTE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La demande n''est pas en attente.';
    END IF;

    -- Vérifier la cohérence des dates
    IF v_dateFin < v_dateDebut THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Les dates de la demande sont invalides.';
    END IF;

    -- Vérifier les conflits avec d'autres réservations du même GardienAnimaux
    SELECT COUNT(*)
    INTO v_conflits
    FROM Reservation R
    JOIN DemandeReservation DR2
        ON DR2.idDemande = R.idDemande
    WHERE DR2.idGardienAnimaux = v_idGardienAnimaux
      AND R.statut IN ('CONFIRMEE', 'EN_COURS')
      AND DR2.dateDebut <= v_dateFin
      AND DR2.dateFin >= v_dateDebut;

    IF v_conflits > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflit : le GardienAnimaux a déjà une réservation dans cette période.';
    END IF;

    -- Calcul du prix total
    SET v_nbJours = DATEDIFF(v_dateFin, v_dateDebut) + 1;
    SET v_prixTotal = v_nbJours * v_tarif;

    -- Mise à jour du statut de la demande
    UPDATE DemandeReservation
    SET statut = 'ACCEPTEE'
    WHERE idDemande = p_idDemande;

    -- Création de la réservation
    INSERT INTO Reservation(idDemande, dateConfirmation, prixTotal, statut)
    VALUES (p_idDemande, CURDATE(), v_prixTotal, 'CONFIRMEE');

    SET v_idReservation = LAST_INSERT_ID();

    -- Création d'un paiement initial en attente
    INSERT INTO Paiement(idReservation, montant, datePaiement, methodePaiement, statutPaiement)
    VALUES (v_idReservation, v_prixTotal, CURDATE(), p_methodePaiement, 'EN_ATTENTE');

    COMMIT;
END //

DELIMITER ;


-- ---------------------------------------------------------
-- Procédure 2 : AnnulerReservation
--
-- But :
-- 1) vérifier que la réservation existe
-- 2) vérifier qu'elle n'est pas déjà annulée
-- 3) annuler la réservation
-- 4) annuler la demande liée
-- 5) rembourser automatiquement si le paiement est déjà PAYE
--
-- Cette procédure automatise une annulation complète avec
-- propagation des effets sur les autres tables.
-- ---------------------------------------------------------

DROP PROCEDURE IF EXISTS AnnulerReservation;
DELIMITER //

CREATE PROCEDURE AnnulerReservation(
    IN p_idReservation INT
)
BEGIN
    DECLARE v_statutReservation VARCHAR(20);
    DECLARE v_statutPaiement VARCHAR(20);
    DECLARE v_idDemande INT;

    -- Gestion des erreurs SQL générales
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur SQL pendant l''annulation de la réservation.';
    END;

    START TRANSACTION;

    -- Récupérer la réservation ciblée
    SELECT idDemande, statut
    INTO v_idDemande, v_statutReservation
    FROM Reservation
    WHERE idReservation = p_idReservation;

    -- Vérifier l'existence
    IF v_statutReservation IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La réservation n''existe pas.';
    END IF;

    -- Vérifier qu'elle n'est pas déjà annulée
    IF v_statutReservation = 'ANNULEE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La réservation est déjà annulée.';
    END IF;

    -- Mise à jour de la réservation
    UPDATE Reservation
    SET statut = 'ANNULEE'
    WHERE idReservation = p_idReservation;

    -- Mise à jour de la demande liée
    UPDATE DemandeReservation
    SET statut = 'ANNULEE'
    WHERE idDemande = v_idDemande;

    -- Vérifier le statut du paiement
    SELECT statutPaiement
    INTO v_statutPaiement
    FROM Paiement
    WHERE idReservation = p_idReservation;

    -- Si le paiement était déjà fait, le marquer comme remboursé
    IF v_statutPaiement = 'PAYE' THEN
        UPDATE Paiement
        SET statutPaiement = 'REMBOURSE'
        WHERE idReservation = p_idReservation;
    END IF;

    COMMIT;
END //

DELIMITER ;


-- =========================================================
-- SECTION 4 - EXEMPLES DE TESTS
-- =========================================================

-- ---------------------------------------------------------
-- Test de la fonction
-- ---------------------------------------------------------
-- SELECT CalculerNoteMoyenneGardienAnimaux(2);


-- ---------------------------------------------------------
-- Test de la procédure d'acceptation
-- ---------------------------------------------------------
-- CALL AccepterDemandeEtCreerReservation(1, 'CARTE');


-- ---------------------------------------------------------
-- Vérification après création
-- ---------------------------------------------------------
-- SELECT * FROM Reservation;
-- SELECT * FROM Paiement;


-- ---------------------------------------------------------
-- Test de la procédure d'annulation
-- ---------------------------------------------------------
-- CALL AnnulerReservation(1);


-- ---------------------------------------------------------
-- Vérification après annulation
-- ---------------------------------------------------------
-- SELECT * FROM Reservation WHERE idReservation = 1;
-- SELECT * FROM Paiement WHERE idReservation = 1;

-- =========================================================
-- FIN DU FICHIER
-- =========================================================
