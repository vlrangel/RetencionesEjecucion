/// <summary>
/// Page Lista Referencias Catastrales (ID 80149).
/// </summary>
page 80149 "Lista Referencias Catastrales"
{
    PageType = List;
    SourceTable = "Ref Catastral Address";
    layout
    {
        area(Content)
        {

            Repeater(Detalle)
            {
                field("Ref. catastral"; Rec."Ref. catastral") { ApplicationArea = All; }
                field("Vendor No."; Rec."Vendor No.") { ApplicationArea = All; }
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Name 2"; Rec."Name 2") { ApplicationArea = All; }
                field(Address; Rec.Address) { ApplicationArea = All; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = All; }
                field(City; Rec.City) { ApplicationArea = All; }
                field(Contact; Rec.Contact) { ApplicationArea = All; }
                field("Phone No."; Rec."Phone No.") { ApplicationArea = All; }
                field("Telex No."; Rec."Telex No.") { ApplicationArea = All; }
                field("Country/Region Code"; Rec."Country/Region Code") { ApplicationArea = All; }
                field("Last Date Modified"; Rec."Last Date Modified") { ApplicationArea = All; }
                field("Fax No."; Rec."Fax No.") { ApplicationArea = All; }
                field("Telex Answer Back"; Rec."Telex Answer Back") { ApplicationArea = All; }
                field("Post Code"; Rec."Post Code") { ApplicationArea = All; }
                field(County; Rec.County) { ApplicationArea = All; }
                field("E-Mail"; Rec."E-Mail") { ApplicationArea = All; }
                field("Home Page"; Rec."Home Page") { ApplicationArea = All; }
                field("Situación inmueble"; Rec."Situación inmueble") { ApplicationArea = All; }
            }
        }
    }
}