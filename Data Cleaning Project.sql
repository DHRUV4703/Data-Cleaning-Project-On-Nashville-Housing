/*
Cleaning Data in SQL Queries
*/

SELECT*
FROM [Portfolio Project].dbo.NashvilleHousing

-----------------------------------------------------------------------

--Standardize Date Format
 SELECT SaleDate, CONVERT(Date,SaleDate)
 FROM [Portfolio Project].dbo.NashvilleHousing

 UPDATE NashvilleHousing
 SET SaleDate = CONVERT(date,Saledate)

 ALTER TABLE NashvileHousing
  ADD SaleDateConverted Date;

   UPDATE NashvilleHousing
 SET SaleDate = CONVERT(date,Saledate)

 ----------------------------------------------------------------------------
 --Populate Property ADDRESS Date
  

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing 
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
---------------------------------------------------------------------------------
--Breaking out Adress into Individual Columns

SELECT PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing 
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING( PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress) - 1) as ADDRESS
,SUBSTRING( PropertyAddress, CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress)) as ADDRESS
FROM [Portfolio Project].dbo.NashvilleHousing 

ALTER TABLE nashvillehousing -- Address
ADD PropertySplitAdress NVARCHAR(255);
UPDATE nashvillehousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE nashvillehousing -- City
ADD PropertySplitCity NVARCHAR(255);
UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

SELECT OwnerAddress
FROM [Portfolio Project].dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM portfolio_project.dbo.nashvillehousing


ALTER TABLE nashvillehousing -- Address
ADD OwnerSplitAdress NVARCHAR(255);
UPDATE nashvillehousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE nashvillehousing -- City
ADD OwnerSplitCity NVARCHAR(255);
UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE nashvillehousing -- State
ADD OwnerSplitState NVARCHAR(255);
UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct (SoldAsVacant),COUNT(SoldAsVacant)
FROM [Portfolio Project].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' Then 'YES'
	   WHEN SoldAsVacant =  'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM [Portfolio Project].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'YES'
	   WHEN SoldAsVacant =  'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END 


-------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select*,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num


FROM [Portfolio Project].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

-------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

Select*
FROM [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, Taxdistrict, PropertyAddress

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate









