FOR EACH ae_Asset EXCLUSIVE-LOCK:
    DELETE ae_Asset.
END.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 1
       ae_Asset.AssetType = 'Bus'
       ae_Asset.AssetName = 'Joburg to Durban'
       ae_Asset.Schedule = '07:00 AM'
       ae_Asset.Capacity = 50
       ae_Asset.BasePrice = 600.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 2
       ae_Asset.AssetType = 'Bus'
       ae_Asset.AssetName = 'Joburg to Cape Town'
       ae_Asset.Schedule = '08:30 AM'
       ae_Asset.Capacity = 40
       ae_Asset.BasePrice = 1000.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 3
       ae_Asset.AssetType = 'Bus'
       ae_Asset.AssetName = 'Cape Town to Joburg'
       ae_Asset.Schedule = '10:00 AM'
       ae_Asset.Capacity = 40
       ae_Asset.BasePrice = 1000.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 4
       ae_Asset.AssetType = 'Bus'
       ae_Asset.AssetName = 'Durban to Joburg'
       ae_Asset.Schedule = '09:00 PM'
       ae_Asset.Capacity = 50
       ae_Asset.BasePrice = 600.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 5
       ae_Asset.AssetType = 'Hotel'
       ae_Asset.AssetName = 'Room 101 - Sea View'
       ae_Asset.Schedule = 'Check-in 14:00'
       ae_Asset.Capacity = 1
       ae_Asset.BasePrice = 1200.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 6
       ae_Asset.AssetType = 'Hotel'
       ae_Asset.AssetName = 'Room 102 - Standard'
       ae_Asset.Schedule = 'Check-in 14:00'
       ae_Asset.Capacity = 1
       ae_Asset.BasePrice = 800.

CREATE ae_Asset.
ASSIGN ae_Asset.AssetID = 8
       ae_Asset.AssetType = 'Salon'
       ae_Asset.AssetName = 'Full Color Treatment'
       ae_Asset.Schedule = '10:00 AM'
       ae_Asset.Capacity = 1
       ae_Asset.BasePrice = 1500.

MESSAGE 'Multi-Industry Assets loaded successfully.' VIEW-AS ALERT-BOX.
