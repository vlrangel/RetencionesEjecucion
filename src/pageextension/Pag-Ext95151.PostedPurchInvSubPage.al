/// <summary>
/// PageExtension PostedPurchInvoiceSubPage (ID 80249).
/// </summary>
pageextension 95151 PostedPurchInvSubPage Extends "Posted Purch. Invoice Subform"
{
    layout
    {

        addbefore("Line Amount")
        {

            field("% retención (BE)"; Rec."% retención (BE)") { ApplicationArea = All; Visible = False; }


            field("Importe retención (BE)"; Rec."Importe retención (BE)") { ApplicationArea = All; Visible = False; }


            field("% retención (IRPF)"; Rec."% retención (IRPF)") { ApplicationArea = All; }


            field("Importe retención (IRPF)"; Rec."Importe retención (IRPF)") { ApplicationArea = All; }
            field("Referencia Catastral"; Rec."Ref. catastral inmueble SII") { ApplicationArea = All; }
        }
        modify(Control7)
        {
            Visible = not (Ret or Be);
        }
        addafter(Control7)
        {
            group(Irpf)
            {
                ShowCaption = false;
                Visible = Ret;
                field("Total importe sin Iva"; TotalPurchInvHeader.Amount)
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
                field("Total Iva"; TotalPurchInvHeader."Amount Including VAT" - TotalPurchInvHeader.Amount)
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
                field("Total imprte sin Iva"; TotalPurchInvHeader.Amount)
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


                field("TotalIva"; TotalPurchInvHeader."Amount Including VAT" - TotalPurchInvHeader.Amount)
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
        TotalPurchCrMemoHdr: Record 122;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsFoundation: Boolean;
        Be: Boolean;
        Ret: Boolean;
        Currency: Record Currency;

    trigger OnAfterGetRecord()
    BEGIN

        DocumentTotals.CalculatePostedPurchInvoiceTotals(TotalPurchCrMemoHdr, VATAmount, Rec);
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
/// PageExtension FacturaCompraKuara (ID 80107) extends Record Purchase Invoice.
/// </summary>
pageextension 95167 "PostCompraIrpf" extends "Posted Purchase Invoice"
{
    layout
    {

        addafter("Payment Method Code")
        {
            Field("Código grupo retención (BE)"; Rec."Código grupo retención (BE)")
            {
                ApplicationArea = All;

            }


            field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
            {
                ApplicationArea = All;


            }


        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Código grupo retención (BE)" <> '') then begin
            CurrPage.PurchInvLines.Page.MostrarRetenciones(true, false);
        end;
        if (Rec."Código grupo retención (IRPF)" <> '') then begin
            CurrPage.PurchInvLines.Page.MostrarRetenciones(false, true);
        end;
    end;

}