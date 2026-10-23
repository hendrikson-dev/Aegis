FOR EACH fp_Booking EXCLUSIVE-LOCK:
DELETE fp_Booking. END.

FOR EACH fp_Customer EXCLUSIVE-LOCK:
DELETE fp_Customer. END.

FOR EACH fp_Segment EXCLUSIVE-LOCK:
DELETE fp_Segment. END.

CREATE fp_Segment.
ASSIGN fp_Segment.SegName = 'New'
       fp_Segment.MinOrders = 0
       fp_Segment.MinSpend = 0
       fp_Segment.FloorPct = 90
       fp_Segment.DiscountPct = 0.
       
CREATE fp_Segment.
ASSIGN fp_Segment.SegName = 'Regular'
       fp_Segment.MinOrders = 3
       fp_Segment.MinSpend = 1000
       fp_Segment.FloorPct = 85
       fp_Segment.DiscountPct = 5.
       
CREATE fp_Segment.
ASSIGN fp_Segment.SegName = 'Loyal'
       fp_Segment.MinOrders = 8
       fp_Segment.MinSpend = 4000
       fp_Segment.FloorPct = 80
       fp_Segment.DiscountPct = 10.
       
CREATE fp_Segment.
ASSIGN fp_Segment.SegName = 'VIP'
       fp_Segment.MinOrders = 15
       fp_Segment.MinSpend = 10000
       fp_Segment.FloorPct = 99
       fp_Segment.DiscountPct = 15.
       
CREATE fp_Customer.
ASSIGN fp_Customer.CustNum = 1
       fp_Customer.NAME = 'Customer One'
       fp_Customer.RegDate = TODAY.

CREATE fp_Customer.       
ASSIGN fp_Customer.CustNum = 2
       fp_Customer.NAME = 'Customer Two'
       fp_Customer.RegDate = TODAY. 
       
CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 1
       fp_Booking.CustNum = 1
       fp_Booking.PricePaid = 500.

CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 2
       fp_Booking.CustNum = 1
       fp_Booking.PricePaid = 500.       

CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 3
       fp_Booking.CustNum = 1
       fp_Booking.PricePaid = 500.  
       
 DEFINE VARIABLE iCust AS INTEGER NO-UNDO.
 DEFINE VARIABLE iSeg AS INTEGER NO-UNDO.
 DEFINE VARIABLE iBook AS INTEGER NO-UNDO.
 
 FOR EACH fp_Customer NO-LOCK: 
        iCust = iCust + 1.
 END.
       
 FOR EACH fp_Segment NO-LOCK: 
        iSeg = iSeg + 1.
 END.
  
 FOR EACH fp_Booking NO-LOCK: 
        iBook = iBook + 1.
 END.
 
 DISPLAY "Customers: " iCust "Segments: " iSeg "Bookings: " iBook.
