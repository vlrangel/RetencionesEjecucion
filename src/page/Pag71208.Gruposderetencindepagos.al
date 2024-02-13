/// <summary>
/// Page Grupos de retención de pagos (ID 7001198).
/// </summary>
Page 71208 "Grupos de retención de pagos"
{

    Caption = 'Grupos de retención de pagos';
    SourceTable = "Grupo de retención de pagos";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {

            Repeater(detalle)
            {

                field(Code; Rec.Code) { ApplicationArea = All; }

                field(Description; Rec.Description) { ApplicationArea = All; }

                field("Retention Type"; Rec."Retention Type") { ApplicationArea = All; }

                field("Retention Base"; Rec."Retention Base") { ApplicationArea = All; }

                field("% Retention"; Rec."% Retention") { ApplicationArea = All; }

                field("Retention Action"; Rec."Retention Action") { ApplicationArea = All; }

                field("Warranty Period"; Rec."Warranty Period") { ApplicationArea = All; }

                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field("Referencia Catastral Obligatoria"; Rec."Referencia Cat. Obligatoria") { ApplicationArea = All; }

            }
        }
    }
    actions
    {
        area(Processing)
        {

        }
    }
}