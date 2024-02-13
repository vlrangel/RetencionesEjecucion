/// <summary>
/// PageExtension FacturaCompraKuara (ID 80107) extends Record Purchase Invoice.
/// </summary>
pageextension 95161 "FacturaCompraIrpf" extends "Purchase Invoice"
{
    layout
    {

        addafter("Payment Method Code")
        {
            Field("Código grupo retención (BE)"; Rec."Código grupo retención (BE)")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if (Rec."Código grupo retención (BE)" <> '') then begin
                        CurrPage.PurchLines.Page.MostrarRetenciones(true, false);
                    end;
                end;
            }


            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if (Rec."Código grupo retención (IRPF)" <> '') then begin
                        CurrPage.PurchLines.Page.MostrarRetenciones(false, true);
                    end;
                end;
            }



        }

    }



    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.PurchLines.Page.MostrarRetenciones(true, false);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.PurchLines.Page.MostrarRetenciones(false, true);
        end;
    end;


}