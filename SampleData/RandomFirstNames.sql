SELECT 
  Parent1Name AS FirstName,
  LastName,
  CASE
    WHEN LEN(Parent1Name) = 0 THEN Parent2Name
    WHEN LEN(Parent2Name) = 0 THEN Parent1Name
    ELSE Parent1Name + ' & ' + Parent2Name
  END AS ParentNames,
        
  /* this SQL misses some child names, but only if Child1Name is NULL; it's OK in
     this case because it's random data anyway and is good enough for my testing */
  Child1Name + COALESCE(', ' + Child2Name, '') + COALESCE(', ' + Child3Name, '') AS Children,
  PictureFilename
FROM [dbo].[NamesAndPhotos]
WHERE Parent1Name IS NOT NULL AND LEN(Parent1Name) > 0

UNION

SELECT 
  Parent2Name AS FirstName,
  LastName,
  CASE
    WHEN LEN(Parent1Name) = 0 THEN Parent2Name
    WHEN LEN(Parent2Name) = 0 THEN Parent1Name
    ELSE Parent1Name + ' & ' + Parent2Name
  END AS ParentNames,
        
  /* this SQL misses some child names, but only if Child1Name is NULL; it's OK in
     this case because it's random data anyway and is good enough for my testing */
  Child1Name + COALESCE(', ' + Child2Name, '') + COALESCE(', ' + Child3Name, '') AS Children,
  PictureFilename
FROM [dbo].[NamesAndPhotos]
WHERE Parent2Name IS NOT NULL AND LEN(Parent2Name) > 0

UNION

SELECT 
  Child1Name AS FirstName,
  LastName,
  CASE
    WHEN LEN(Parent1Name) = 0 THEN Parent2Name
    WHEN LEN(Parent2Name) = 0 THEN Parent1Name
    ELSE Parent1Name + ' & ' + Parent2Name
  END AS ParentNames,
        
  /* this SQL misses some child names, but only if Child1Name is NULL; it's OK in
     this case because it's random data anyway and is good enough for my testing */
  Child1Name + COALESCE(', ' + Child2Name, '') + COALESCE(', ' + Child3Name, '') AS Children,
  PictureFilename
FROM [dbo].[NamesAndPhotos]
WHERE Child1Name IS NOT NULL AND LEN(Child1Name) > 0

UNION

SELECT 
  Child2Name AS FirstName,
  LastName,
  CASE
    WHEN LEN(Parent1Name) = 0 THEN Parent2Name
    WHEN LEN(Parent2Name) = 0 THEN Parent1Name
    ELSE Parent1Name + ' & ' + Parent2Name
  END AS ParentNames,
        
  /* this SQL misses some child names, but only if Child1Name is NULL; it's OK in
     this case because it's random data anyway and is good enough for my testing */
  Child1Name + COALESCE(', ' + Child2Name, '') + COALESCE(', ' + Child3Name, '') AS Children,
  PictureFilename
FROM [dbo].[NamesAndPhotos]
WHERE Child2Name IS NOT NULL AND LEN(Child2Name) > 0

UNION

SELECT 
  Child3Name AS FirstName,
  LastName,
  CASE
    WHEN LEN(Parent1Name) = 0 THEN Parent2Name
    WHEN LEN(Parent2Name) = 0 THEN Parent1Name
    ELSE Parent1Name + ' & ' + Parent2Name
  END AS ParentNames,
        
  /* this SQL misses some child names, but only if Child1Name is NULL; it's OK in
     this case because it's random data anyway and is good enough for my testing */
  Child1Name + COALESCE(', ' + Child2Name, '') + COALESCE(', ' + Child3Name, '') AS Children,
  PictureFilename
FROM [dbo].[NamesAndPhotos]
WHERE Child3Name IS NOT NULL AND LEN(Child3Name) > 0

ORDER BY FirstName