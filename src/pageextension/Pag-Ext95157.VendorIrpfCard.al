/// <summary>
/// PageExtension VendorCard (ID 80137) extends Record Vendor Card.
/// </summary>
pageextension 95157 VendorIrpfCard extends "Vendor Card"
{
    layout
    {
        addafter("Prices Including VAT")
        {
            Field("Código grupo retención (BE)"; Rec."Código grupo retención (BE)") { ApplicationArea = All; }

            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)") { ApplicationArea = All; }


        }


    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            Action("Movimientos retención")
            {
                ApplicationArea = All;
                RunObject = Page "Mov. retención de pagos";
                RunPageLink = Type = CONST(Vendor),
                                  "No." = FIELD("No.");
                Image = ReturnRelated;
            }
            action("Asigna IRPF")
            {
                Image = TaxPayment;
                ApplicationArea = All;
                trigger OnAction()
                var
                    rGr: Record "Grupo de retención de pagos";
                    rRes: Record Vendor;

                begin

                    IF Page.RUNMODAL(0, rGr) = ACTION::LookupOK THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(rRes);
                        IF rRes.FINDFIRST THEN
                            REPEAT
                                rRes."Código grupo retención (IRPF)" := rGr.Code;
                                rRes.Modify();
                            UNTIL rRes.NEXT = 0;

                    END;
                end;
            }



        }
        addlast(Category_Process)
        {
            actionref("Movimientos retención_Promoted"; "Movimientos retención")
            {
            }
        }



    }

    //onaftergetrecord() llamar a activatefields y obtenercomentarios

}