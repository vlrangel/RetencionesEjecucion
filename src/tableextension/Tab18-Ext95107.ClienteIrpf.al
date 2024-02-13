/// <summary>
/// TableExtension ClienteIRPF (ID 80107) extends Record Customer.
/// </summary>
tableextension 95107 ClienteIrpf extends "Customer" //18
{
    fields
    {



        field(92000; "Código grupo retención (BE)"; Code[20])
        {
            Caption = 'Código grupo retención (BE)';
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST("Good Execution"));
            DataClassification = ToBeClassified;
        }
        field(92001; "Código grupo retención (IRPF)"; Code[20])
        {
            Caption = 'Código grupo retención (IRPF)';
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST(IRPF));
            DataClassification = ToBeClassified;
        }


    }


}