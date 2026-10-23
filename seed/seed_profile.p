FOR EACH fp_Profile EXCLUSIVE-LOCK:
    DELETE fp_Profile.
END.

CREATE fp_Profile.
ASSIGN fp_Profile.ProfileName  = 'Bus'
       fp_Profile.UnitName     = 'seats'
       fp_Profile.Capacity     = 90
       fp_Profile.StartPrice   = 500
       fp_Profile.Drop1Price   = 470
       fp_Profile.Drop2Price   = 420
       fp_Profile.MarginalCost = 300
       fp_Profile.WindowHours  = 72.

CREATE fp_Profile.
ASSIGN fp_Profile.ProfileName  = 'Hotel'
       fp_Profile.UnitName     = 'rooms'
       fp_Profile.Capacity     = 40
       fp_Profile.StartPrice   = 1200
       fp_Profile.Drop1Price   = 1100
       fp_Profile.Drop2Price   = 950
       fp_Profile.MarginalCost = 1100
       fp_Profile.WindowHours  = 168.

CREATE fp_Profile.
ASSIGN fp_Profile.ProfileName  = 'Salon'
       fp_Profile.UnitName     = 'slots'
       fp_Profile.Capacity     = 12
       fp_Profile.StartPrice   = 250
       fp_Profile.Drop1Price   = 230
       fp_Profile.Drop2Price   = 200
       fp_Profile.MarginalCost = 60
       fp_Profile.WindowHours  = 24.

MESSAGE 'Profiles seeded (Bus, Hotel, Salon).' VIEW-AS ALERT-BOX INFORMATION.
