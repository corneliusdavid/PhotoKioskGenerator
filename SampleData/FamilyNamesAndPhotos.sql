USE [NamesWithPhotos]
GO

/****** Object:  Table [dbo].[NamesAndPhotos]    Script Date: 4/27/2017 8:52:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NamesAndPhotos](
	[ID] [int] NOT NULL,
	[LastName] [varchar](50) NULL,
	[Parent1Name] [varchar](50) NULL,
	[Parent2Name] [varchar](50) NULL,
	[ChildNames] [varchar](100) NULL,
	[PictureFilename] [varchar](200) NULL,
	[HasPicture] [bit] NOT NULL
) ON [PRIMARY]

GO


