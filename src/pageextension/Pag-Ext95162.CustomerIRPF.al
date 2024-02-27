/// <summary>
/// PageExtension CustomerIRPF (ID 80134) extends Record Customer Card.
/// </summary>
pageextension 95162 CustomerIRPF extends "Customer Card"
{

    // Permissions=TableData 21=rimd,
    //         TableData 25=rimd,
    //         TableData 379=rimd,
    //         TableData 380=rimd;

    layout
    {
        addlast(content)
        {
            group(Retenciones)
            {
                field("Código grupo retención (BE)"; Rec."Código grupo retención (BE)")
                {
                    ApplicationArea = All;
                    Caption = 'Código Grupo Retention (GE)';

                }
                field("Código grupo retención (IRPF)"; Rec."Código grupo retención (IRPF)")
                {
                    ApplicationArea = All;
                    Caption = 'Código Grupo Retention (IRPF)';

                }
            }
        }

    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            Action("Movimientos retención")
            {
                ApplicationArea = All;

                RunObject = Page "Mov. retención de pagos";
                RunPageLink = Type = CONST(Customer),
                                  "No." = FIELD("No.");
                Promoted = true;
                Image = ReturnRelated;
                PromotedCategory = Category9;
            }
        }







        // addlast(navigation)
        // {
        //     actionref("Movimientos retención"; Movimientosretencion)
        //     {

        //     }
        // }



    }


}