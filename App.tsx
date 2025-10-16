import { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './components/ui/tabs';
import { Calculator, Users, FileText, Activity } from 'lucide-react';
import { PatientList } from './components/PatientList';
import { InsulinCalculator } from './components/InsulinCalculator';
import { PatientDetails } from './components/PatientDetails';
import { Guidelines } from './components/Guidelines';

export interface Patient {
  id: string;
  name: string;
  age: number;
  weight: number;
  admission: string;
  diagnosis: string;
  insulinType: 'basal-bolus' | 'correction-only' | 'premixed';
  basalDose?: number;
  correctionFactor?: number;
  target: { min: number; max: number };
  lastGlycemia?: number;
  lastUpdate?: string;
}

export default function App() {
  const [patients, setPatients] = useState<Patient[]>([
    {
      id: '1',
      name: 'Maria Silva',
      age: 65,
      weight: 72,
      admission: '2025-10-14',
      diagnosis: 'Diabetes Mellitus tipo 2 descompensado',
      insulinType: 'basal-bolus',
      basalDose: 18,
      correctionFactor: 50,
      target: { min: 100, max: 140 },
      lastGlycemia: 186,
      lastUpdate: '2025-10-16T08:30',
    },
    {
      id: '2',
      name: 'João Santos',
      age: 58,
      weight: 85,
      admission: '2025-10-15',
      diagnosis: 'Hiperglicemia secundária a corticoterapia',
      insulinType: 'correction-only',
      correctionFactor: 40,
      target: { min: 100, max: 150 },
      lastGlycemia: 220,
      lastUpdate: '2025-10-16T06:00',
    },
  ]);
  
  const [selectedPatient, setSelectedPatient] = useState<Patient | null>(null);
  const [activeTab, setActiveTab] = useState('patients');

  const updatePatient = (updatedPatient: Patient) => {
    setPatients(patients.map(p => p.id === updatedPatient.id ? updatedPatient : p));
    setSelectedPatient(updatedPatient);
  };

  const addPatient = (patient: Patient) => {
    setPatients([...patients, patient]);
  };

  const deletePatient = (id: string) => {
    setPatients(patients.filter(p => p.id !== id));
    if (selectedPatient?.id === id) {
      setSelectedPatient(null);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50">
      {/* Header */}
      <header className="bg-white border-b shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="bg-indigo-600 p-2 rounded-lg">
                <Activity className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-indigo-900">InsuGuia Mobile</h1>
                <p className="text-gray-600 text-sm">
                  Sistema de Prescrição de Insulina - SBD 2025
                </p>
              </div>
            </div>
            <div className="text-right">
              <p className="text-gray-600 text-sm">
                Pacientes Não Críticos
              </p>
              <p className="text-indigo-600 text-sm">
                {patients.length} paciente{patients.length !== 1 ? 's' : ''} ativo{patients.length !== 1 ? 's' : ''}
              </p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
          <TabsList className="grid w-full grid-cols-4 mb-6">
            <TabsTrigger value="patients" className="flex items-center gap-2">
              <Users className="w-4 h-4" />
              Pacientes
            </TabsTrigger>
            <TabsTrigger value="calculator" className="flex items-center gap-2">
              <Calculator className="w-4 h-4" />
              Calculadora
            </TabsTrigger>
            <TabsTrigger value="details" className="flex items-center gap-2" disabled={!selectedPatient}>
              <Activity className="w-4 h-4" />
              Detalhes
            </TabsTrigger>
            <TabsTrigger value="guidelines" className="flex items-center gap-2">
              <FileText className="w-4 h-4" />
              Diretrizes
            </TabsTrigger>
          </TabsList>

          <TabsContent value="patients">
            <PatientList
              patients={patients}
              selectedPatient={selectedPatient}
              onSelectPatient={setSelectedPatient}
              onAddPatient={addPatient}
              onDeletePatient={deletePatient}
              onViewDetails={(patient) => {
                setSelectedPatient(patient);
                setActiveTab('details');
              }}
            />
          </TabsContent>

          <TabsContent value="calculator">
            <InsulinCalculator
              selectedPatient={selectedPatient}
              onUpdatePatient={updatePatient}
            />
          </TabsContent>

          <TabsContent value="details">
            {selectedPatient && (
              <PatientDetails
                patient={selectedPatient}
                onUpdatePatient={updatePatient}
              />
            )}
          </TabsContent>

          <TabsContent value="guidelines">
            <Guidelines />
          </TabsContent>
        </Tabs>
      </main>

      {/* Footer */}
      <footer className="mt-12 border-t bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <p className="text-center text-gray-500 text-sm">
            InsuGuia Mobile - Baseado nas diretrizes da Sociedade Brasileira de Diabetes (SBD, 2025)
          </p>
          <p className="text-center text-gray-400 text-xs mt-1">
            Este sistema é uma ferramenta de apoio. A decisão clínica final cabe ao médico prescritor.
          </p>
        </div>
      </footer>
    </div>
  );
}
