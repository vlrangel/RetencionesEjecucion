/// <summary>
/// PageExtension SubFormSCrmemoIrpf (ID 92156) extends Record Sales Cr. Memo Subform.
/// </summary>
Pageextension 95154 SubFormSCrmemoIrpf extends "Sales Cr. Memo Subform"
{

    layout
    {
        addbefore("Line Amount")
        {

            field("% retención (BE)"; Rec."% retención (BE)") { ApplicationArea = All; Visible = be; }


            field("Importe retención (BE)"; Rec."Importe retención (BE)") { ApplicationArea = All; Visible = be; }


            field("% retención (IRPF)"; Rec."% retención (IRPF)") { ApplicationArea = All; Visible = Ret; }


            field("Importe retención (IRPF)"; Rec."Importe retención (IRPF)") { ApplicationArea = All; Visible = Ret; }
        }
        modify(Control17)
        {
            Visible = not (Ret or Be);
        }
        addafter(Control17)
        {
            group(Irpf)
            {
                ShowCaption = false;
                Visible = Ret;
                field("Total importe sin Iva"; TotalSalesLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                    Caption = 'Total Iva Excl';
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                }



                field("Total Importe retención (IRPF)"; -TotalInvoiceHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;

                    Caption = 'Retención IRPF total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalInvoiceHdr."Currency Code";
                    Editable = FALSE;

                }
                field("Total Iva"; TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'Iva Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tot factura"; TotalSalesLine."Amount Including VAT" - TotalInvoiceHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura (EUR)';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalInvoiceHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalInvoiceHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
            group(Be)
            {
                ShowCaption = false;
                Visible = Be;
                field("Total imprte sin Iva"; TotalSalesLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                    Caption = 'Total IVA excl. (EUR)';
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                }

                field("Total Importe retención (BE)"; -TotalInvoiceHdr."Importe retención (BE)")
                {
                    ApplicationArea = All;
                    Caption = 'Retención BE total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalInvoiceHdr."Currency Code";
                    Editable = FALSE;

                }


                field("TotalIva"; TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'IVA Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tota factura"; TotalSalesLine."Amount Including VAT" - TotalInvoiceHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalInvoiceHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalInvoiceHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
        }
    }

    VAR
        TotalInvoiceHdr: Record 37;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsFoundation: Boolean;
        Be: Boolean;
        Ret: Boolean;
        Currency: Record Currency;

    trigger OnAfterGetCurrRecord()
    BEGIN
        TotalInvoiceHdr.SetRange("Document Type", Rec."Document Type");
        TotalInvoiceHdr.SetRange("Document No.", Rec."Document No.");
        // EC-JRJOFRE
        TotalInvoiceHdr.CALCsums("Importe retención (BE)", "Importe retención (IRPF)");
        // EC-JRJOFRE - FIN
        Ret := false;
        Be := false;
        If TotalInvoiceHdr."Importe retención (BE)" <> 0 THEN
            Be := TRUE;
        If TotalInvoiceHdr."Importe retención (IRPF)" <> 0 THEN
            Ret := TRUE;
    END;

    trigger OnOpenPage()
    begin
        Currency.InitRoundingPrecision();
    end;

    Procedure MostrarRetenciones(pRet: Boolean; pBe: Boolean);
    begin
        Be := pBe;
        Ret := pRet;
        CurrPage.UPDATE(false);
    end;
}