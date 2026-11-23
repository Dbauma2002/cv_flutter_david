CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE users ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE users ADD COLUMN IF NOT EXISTS full_name VARCHAR(120);
UPDATE users
SET full_name = split_part(email, '@', 1)
WHERE full_name IS NULL;
ALTER TABLE users ALTER COLUMN full_name SET NOT NULL;

CREATE TABLE IF NOT EXISTS family_templates (
    template_key VARCHAR(80) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    lien VARCHAR(80) NOT NULL,
    profession VARCHAR(120) NOT NULL,
    photo_url VARCHAR(2048)
);

CREATE TABLE IF NOT EXISTS family_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nom VARCHAR(100) NOT NULL,
    lien VARCHAR(80) NOT NULL,
    profession VARCHAR(120) NOT NULL,
    photo_url VARCHAR(2048),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS id UUID DEFAULT gen_random_uuid();
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS nom VARCHAR(100);
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS lien VARCHAR(80);
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS profession VARCHAR(120);
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS photo_url VARCHAR(2048);
ALTER TABLE family_members
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE family_members ALTER COLUMN id SET DEFAULT gen_random_uuid();

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'family_members'
          AND column_name = 'full_name'
    ) THEN
        EXECUTE 'UPDATE family_members SET nom = full_name WHERE nom IS NULL';
        EXECUTE 'ALTER TABLE family_members DROP COLUMN full_name';
    END IF;
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'family_members'
          AND column_name = 'name'
    ) THEN
        EXECUTE 'UPDATE family_members SET nom = name WHERE nom IS NULL';
        EXECUTE 'ALTER TABLE family_members DROP COLUMN name';
    END IF;
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'family_members'
          AND column_name = 'relationship'
    ) THEN
        EXECUTE 'UPDATE family_members SET lien = relationship WHERE lien IS NULL';
        EXECUTE 'ALTER TABLE family_members DROP COLUMN relationship';
    END IF;
END $$;

UPDATE family_members SET nom = 'Membre' WHERE nom IS NULL;
UPDATE family_members SET lien = 'Famille' WHERE lien IS NULL;
UPDATE family_members SET profession = 'Non renseignée' WHERE profession IS NULL;
ALTER TABLE family_members ALTER COLUMN nom SET NOT NULL;
ALTER TABLE family_members ALTER COLUMN lien SET NOT NULL;
ALTER TABLE family_members ALTER COLUMN profession SET NOT NULL;
CREATE INDEX IF NOT EXISTS ix_family_members_user_id
    ON family_members (user_id);

INSERT INTO family_templates (template_key, nom, lien, profession, photo_url)
VALUES
    ('pere', 'Joseph Bauma', 'Père', 'Commerçant', 'assets/images/pere.jpg'),
    ('mere', 'Bazungu Analiza', 'Mère', 'Enseignante', 'assets/images/mere.jpg'),
    ('frere', 'Richard Mahatma', 'Frère aîné', 'Docteur', 'assets/images/frere.jpg'),
    ('soeur', 'Beatrice', 'Sœur cadette', 'Élève', 'assets/images/soeur.jpg')
ON CONFLICT (template_key) DO UPDATE SET
    nom = EXCLUDED.nom,
    lien = EXCLUDED.lien,
    profession = EXCLUDED.profession,
    photo_url = EXCLUDED.photo_url;

INSERT INTO family_members (user_id, nom, lien, profession, photo_url)
SELECT users.id, legacy.nom, legacy.lien, legacy.profession,
       legacy.photo_url
FROM users
CROSS JOIN family_members AS legacy
WHERE legacy.user_id IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM family_members AS owned
      WHERE owned.user_id = users.id
        AND owned.nom = legacy.nom
  );

DELETE FROM family_members
WHERE user_id IS NULL
  AND EXISTS (SELECT 1 FROM users);

INSERT INTO family_members (user_id, nom, lien, profession, photo_url)
SELECT users.id, templates.nom, templates.lien, templates.profession,
       templates.photo_url
FROM users
CROSS JOIN family_templates AS templates
WHERE NOT EXISTS (
    SELECT 1
    FROM family_members AS members
    WHERE members.user_id = users.id
      AND members.nom = templates.nom
);
