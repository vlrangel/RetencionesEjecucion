/// <summary>
/// TableExtension Purchase LineIRPF (ID 80151) extends Record Purchase Line.
/// </summary>
tableextension 95151 "Purchase LineIRPF" extends "Purchase Line" //39
{
    fields
    {

        field(91000; "% retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (BE)';
        }
        field(92001; "% retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (IRPF)';
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (BE)';
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (IRPF)';
        }
        field(92004; "Ref. catastral inmueble SII"; TEXT[30])
        {
            DataClassification = ToBeClassified;

            Caption = 'Ref. catastral inmueble SII';
        }




    }

}