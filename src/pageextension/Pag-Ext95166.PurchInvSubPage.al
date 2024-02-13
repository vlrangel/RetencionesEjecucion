/// <summary>
/// PageExtension PurchInvoiceSubPage (ID 80210).
/// </summary>
pageextension 95166 PurchInvSubPage Extends "Purch. Invoice Subform"
{
    layout
    {

        addbefore("Line Amount")
        {

            field("% retención (BE)"; Rec."% retención (BE)") { ApplicationArea = All; Visible = be; }



            field("Importe retención (BE)"; Rec."Importe retención (BE)") { ApplicationArea = All; Visible = be; }


            field("% retención (IRPF)"; Rec."% retención (IRPF)") { ApplicationArea = All; Visible = Ret; }


            field("Importe retención (IRPF)"; Rec."Importe retención (IRPF)") { ApplicationArea = All; Visible = Ret; }
            field("Referencia Catastral"; Rec."Ref. catastral inmueble SII") { ApplicationArea = All; Visible = Ret; }

        }
        modify(Control15)
        {
            Visible = not (Ret or Be);
        }
        addafter(Control15)
        {
            group(Irpf)
            {
                ShowCaption = false;
                Visible = Ret;
                field("Total importe sin Iva"; TotalPurchaseLine.Amount)
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



                field("Total Importe retención (IRPF)"; -TotalPurchHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;

                    Caption = 'Retención IRPF total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchHdr."Currency Code";
                    Editable = FALSE;

                }
                field("Total Iva"; TotalPurchaseLine."Amount Including VAT" - TotalPurchaseLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'Iva Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tot factura"; TotalPurchaseLine."Amount Including VAT" - TotalPurchHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura (EUR)';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalPurchHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalPurchHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
            group(Be)
            {
                ShowCaption = false;
                Visible = Be;
                field("Total imprte sin Iva"; TotalPurchaseLine.Amount)
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

                field("Total Importe retención (BE)"; -TotalPurchHdr."Importe retención (BE)")
                {
                    ApplicationArea = All;
                    Caption = 'Retención BE total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchHdr."Currency Code";
                    Editable = FALSE;

                }


                field("TotalIva"; TotalPurchaseLine."Amount Including VAT" - TotalPurchaseLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                    Caption = 'IVA Total (EUR)';
                    Editable = false;
                    ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';

                }

                field("Tota factura"; TotalPurchaseLine."Amount Including VAT" - TotalPurchHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Total factura';
                    AutoFormatType = 1;
                    Style = Strong;
                    // Visible = (TotalPurchHdr."Importe retención (IRPF)" <> 0);
                    AutoFormatExpression = TotalPurchHdr."Currency Code";
                    Editable = FALSE;
                    //Visible = (Be Or Ret);
                }
            }
        }

    }

    VAR
        Currency: Record Currency;
        TransferExtendedText: Codeunit 378;
        PurchInfoPaneMgt: Codeunit 7181;
        PurchHeader: Record 38;
        //PurchPriceCalcMgt: Codeunit 7010;
        TotalPurchHdr: Record 39;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsFoundation: Boolean;
        Ret: Boolean;
        Be: Boolean;

    trigger OnOpenPage()
    begin
        Currency.InitRoundingPrecision();
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchHeader: Record 38;
    BEGIN

        TotalPurchHdr.SetRange("Document Type", Rec."Document Type");
        TotalPurchHdr.SetRange("Document No.", Rec."Document No.");
        If TotalPurchHdr.Findfirst Then
            // EC-JRJOFRE
            TotalPurchHdr.CALCsums("Importe retención (BE)", "Importe retención (IRPF)", Amount, "Amount Including VAT");
        // EC-JRJOFRE - FIN
        Ret := false;
        Be := false;
        If TotalPurchHdr."Importe retención (BE)" <> 0 THEN
            Be := TRUE;
        If TotalPurchHdr."Importe retención (IRPF)" <> 0 THEN
            Ret := TRUE;
        If PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN begin
            iF PurchHeader."Código grupo retención (BE)" <> '' THEN be := true;
            iF PurchHeader."Código grupo retención (IRPF)" <> '' THEN ret := true;
        end;

    END;

    Procedure MostrarRetenciones(pRet: Boolean; pBe: Boolean);
    begin
        Be := pBe;
        Ret := pRet;
        CurrPage.UPDATE(false);
    end;


}
