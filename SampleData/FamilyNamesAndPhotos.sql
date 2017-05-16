USE [NamesWithPhotos]
GO

/****** Object:  Table [dbo].[NamesAndPhotos]    Script Date: 5/13/2017 8:56:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NamesAndPhotos](
	[ID] [int] NOT NULL,
	[LastName] [varchar](50) NULL,
	[Parent1Name] [varchar](50) NULL,
	[Parent2Name] [varchar](50) NULL,
	[Child1Name] [varchar](50) NULL,
	[Child2Name] [varchar](50) NULL,
	[Child3Name] [varchar](50) NULL,
    [PictureFilename] [varchar](200) NULL
	)
	

GO


