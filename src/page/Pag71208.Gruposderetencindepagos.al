/// <summary>
/// Page Grupos de retención de pagos (ID 7001198).
/// </summary>
<<<<<<< HEAD:src/page/Pag71208.Gruposderetencindepagos.al
Page 71208 "Grupos de retención de pagos"
=======
Page 80159 "Grupos de retención de pagos"
>>>>>>> a9ee88a3eea46a4406956a6351f27f14826149ef:src/page/Pag7001208.Gruposderetencindepagos.al
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