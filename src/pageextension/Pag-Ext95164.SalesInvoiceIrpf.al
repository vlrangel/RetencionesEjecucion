/// <summary>
/// PageExtension SalesInvoiceIrpf (ID 95142) extends Record Sales Invoice.
/// </summary>
pageextension 95164 SalesInvoiceIrpf extends "Sales Invoice"
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
                        CurrPage.SalesLines.Page.MostrarRetenciones(false, true);
                    end;
                end;
            }


            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if (Rec."Código grupo retención (IRPF)" <> '') then begin
                        CurrPage.SalesLines.Page.MostrarRetenciones(true, false);
                    end;
                end;
            }


        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(false, true);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(true, false);
        end;
    end;
}
pageextension 95165 Contratos extends "Sales Order"
{
    layout
    {
        addfirst("Invoice Details")
        {


            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(false, true);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.SalesLines.Page.MostrarRetenciones(true, false);
        end;
    end;
}