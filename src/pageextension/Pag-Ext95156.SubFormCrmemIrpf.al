/// <summary>
/// PageExtension SubFormCrmemIrpf (ID 92158) extends Record Purch. Cr. Memo Subform.
/// </summary>
Pageextension 95156 SubFormCrmemIrpf extends "Purch. Cr. Memo Subform"
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
        modify(Control47)
        {
            Visible = not (Ret or Be);
        }
        addafter(Control47)
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



                field("Total Importe retención (IRPF)"; -TotalPurchCrMemoHdr."Importe retención (IRPF)")
                {
                    ApplicationArea = All;

                    Caption = 'Retención IRPF total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
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

                field("Tot factura"; TotalPurchaseLine."Amount Including VAT" - TotalPurchCrMemoHdr."Importe retención (IRPF)")
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

                field("Total Importe retención (BE)"; -TotalPurchCrMemoHdr."Importe retención (BE)")
                {
                    ApplicationArea = All;
                    Caption = 'Retención BE total';
                    AutoFormatType = 1;
                    Style = Attention;
                    AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
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

                field("Tota factura"; TotalPurchaseLine."Amount Including VAT" - TotalPurchCrMemoHdr."Importe retención (IRPF)")
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
        TotalPurchCrMemoHdr: Record 39;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsFoundation: Boolean;
        Be: Boolean;
        Ret: Boolean;
        Currency: Record Currency;

    trigger OnAfterGetCurrRecord()
    BEGIN

        TotalPurchCrMemoHdr.SetRange("Document Type", Rec."Document Type");
        TotalPurchCrMemoHdr.SetRange("Document No.", Rec."Document No.");
        // EC-JRJOFRE
        TotalPurchCrMemoHdr.CALCsums("Importe retención (BE)", "Importe retención (IRPF)", "Amount Including VAT", Amount);
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