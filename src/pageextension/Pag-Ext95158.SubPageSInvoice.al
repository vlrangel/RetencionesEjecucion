/// <summary>
/// PageExtension SubPageSInvoice (ID 92161) extends Record Posted Sales Invoice Subform.
/// </summary>
Pageextension 95158 SubPageSInvoice extends "Posted Sales Invoice Subform"
{

    layout
    {
        addbefore("Line Amount")
        {

            field("% retención (BE)"; Rec."% retención (BE)") { ApplicationArea = All; Visible = False; }


            field("Importe retención (BE)"; Rec."Importe retención (BE)") { ApplicationArea = All; Visible = False; }


            field("% retención (IRPF)"; Rec."% retención (IRPF)") { ApplicationArea = All; }


            field("Importe retención (IRPF)"; Rec."Importe retención (IRPF)") { ApplicationArea = All; }
        }
        modify(Control28)
        {
            Visible = not (Ret or Be);
        }
        addafter(Control28)
        {
            group(Irpf)
            {
                ShowCaption = false;
                Visible = Ret;
                field("Total importe sin Iva"; TotalPurchCrMemoHdr.Amount)
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



                field("Total Importe retención (IRPF)"; -TotalPurchCrMemoHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;

                    Caption = 'Retención IRPF total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                    Editable = FALSE;

                }
                field("Total Iva"; TotalPurchCrMemoHdr."Amount Including VAT" - TotalPurchCrMemoHdr.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'Iva Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tot factura"; TotalPurchCrMemoHdr."Amount Including VAT" - TotalPurchCrMemoHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura (EUR)';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalPurchCrMemoHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
            group(Be)
            {
                ShowCaption = false;
                Visible = Be;
                field("Total imprte sin Iva"; TotalPurchCrMemoHdr.Amount)
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

                field("Total Importe retención (BE)"; -TotalPurchCrMemoHdr."Importe retención (BE)")
                {
                    ApplicationArea = All;
                    Caption = 'Retención BE total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                    Editable = FALSE;

                }


                field("TotalIva"; TotalPurchCrMemoHdr."Amount Including VAT" - TotalPurchCrMemoHdr.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'IVA Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tota factura"; TotalPurchCrMemoHdr."Amount Including VAT" - TotalPurchCrMemoHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalPurchCrMemoHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
        }

    }


    VAR
        TotalPurchCrMemoHdr: Record 112;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsFoundation: Boolean;
        Be: Boolean;
        Ret: Boolean;
        Currency: Record Currency;

    trigger OnAfterGetRecord()
    BEGIN

        DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalPurchCrMemoHdr, VATAmount, Rec);

        // EC-JRJOFRE
        TotalPurchCrMemoHdr.CALCFIELDS("Importe retención (BE)", "Importe retención (IRPF)");
        // EC-JRJOFRE - FIN
        Ret := false;
        Be := false;
        If TotalPurchCrMemoHdr."Importe retención (BE)" <> 0 THEN
            Be := TRUE;
        If TotalPurchCrMemoHdr."Importe retención (IRPF)" <> 0 THEN
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
/// <summary>
/// PageExtension SalesInvoiceIrpf (ID 95142) extends Record Sales Invoice.
/// </summary>
pageextension 95171 PostedSalesInvoiceIrpf extends "Posted Sales Invoice"
{

    layout
    {
        addafter("Payment Method Code")
        {
            Field("Código grupo retención (BE)"; Rec."Código grupo retención (BE)") { ApplicationArea = All; }

            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)") { ApplicationArea = All; }


        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.SalesInvLines.Page.MostrarRetenciones(true, false);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.SalesInvLines.Page.MostrarRetenciones(false, true);
        end;
    end;
}