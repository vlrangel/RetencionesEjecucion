/// <summary>
/// PageExtension SalesCrmemoIrpf (ID 95141) extends Record Sales Credit Memo.
/// </summary>
pageextension 95163 SalesCrmemoIrpf extends "Sales Credit Memo"
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
                        CurrPage.SalesLines.Page.MostrarRetenciones(true, false);
                    end;
                end;
            }


            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if (Rec."Código grupo retención (IRPF)" <> '') then begin
                        CurrPage.SalesLines.Page.MostrarRetenciones(false, true);
                    end;
                end;
            }


        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(true, false);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(false, true);
        end;
    end;
}